//
//  SRHRacesViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRacesViewModel.h"
#import "SRHRaceCellViewModel.h"
#import "SRHRacesSectionViewModel.h"
#import "SRHNetworkRequests.h"
#import "SRHRace.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RestKit/RestKit.h>

@interface SRHRacesViewModel ()

@property(nonatomic, strong) NSArray *sectionViewModels;
@property(nonatomic, strong) RACSignal *updatedContentSignal;
@property(nonatomic, strong) RACCommand *updateContentCommand;

@end

@implementation SRHRacesViewModel

-(id)init {
    self = [super init];
    if (self) {
        self.updatedContentSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return [[SRHNetworkRequests fetchRaces] subscribeNext:^(NSArray *races) {
                [self createSectionViewModelsFromRaces:races];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to access load races at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }];
        }];
        
        self.updateContentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return self.updatedContentSignal;
        }];
        
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            if (!self.sectionViewModels
                || [self.sectionViewModels count] == 0) {
                [self.updateContentCommand execute:nil];
            }
        }];
    }
    
    return self;
}

-(void)createSectionViewModelsFromRaces:(NSArray *)races {
    NSMutableArray *sectionViewModels = [NSMutableArray array];
    
    NSArray *states = [races valueForKeyPath:@"@distinctUnionOfObjects.state"];
    NSArray *activeStates = [states filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue != %d && integerValue != %d", SRHRaceStateCompleted, SRHRaceStateRaceOver]];
    NSArray *orderedActiveStates = [activeStates sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"integerValue" ascending:YES]]];
    
    for (NSNumber* state in orderedActiveStates)
    {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"state == %d", [state intValue]];
        NSArray* racesWithState = [races filteredArrayUsingPredicate:pred];
        [sectionViewModels addObject:[[SRHRacesSectionViewModel alloc] initWithRaces:racesWithState
                                                                               title:[SRHRace raceStateToString:[state intValue]]
                                                                            iconName:[SRHRace raceStateToIconName:[state intValue]]]];
    }
    
    self.sectionViewModels = sectionViewModels;
}

-(NSInteger)numberOfSections {
    return [self.sectionViewModels count];
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    SRHRacesSectionViewModel *viewModel = self.sectionViewModels[section];
    return viewModel.races.count;
}

-(SRHRace *)itemAtIndexPath:(NSIndexPath *)indexPath {
    SRHRacesSectionViewModel *viewModel = self.sectionViewModels[indexPath.section];
    return viewModel.races[indexPath.row];
}

-(SRHRaceCellViewModel *)viewModelForItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHRacesSectionViewModel *viewModel = self.sectionViewModels[indexPath.section];
    SRHRace *race = viewModel.races[indexPath.item];
    
    return [[SRHRaceCellViewModel alloc] initWithRace:race];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    SRHRacesSectionViewModel *viewModel = self.sectionViewModels[section];
    return viewModel.headerTitle;
}

- (UIImage *)iconForHeaderInSection:(NSInteger)section {
    SRHRacesSectionViewModel *viewModel = self.sectionViewModels[section];
    return [UIImage imageNamed:viewModel.iconName];
}

@end
