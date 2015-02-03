//
//  SRHRaceStreamsViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceStreamsViewModel.h"
#import "SRHRaceStreamCellViewModel.h"
#import "SRHNetworkRequests.h"
#import "SRHStream.h"
#import "SRHRace.h"
#import "SRHGame.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SRHRaceStreamsViewModel ()

@property(nonatomic, strong) NSArray *raceStreams;
@property(nonatomic, strong) RACSignal *updatedContentSignal;
@property(nonatomic, strong) RACCommand *updateContentCommand;

@end

@implementation SRHRaceStreamsViewModel

-(instancetype)initWithRace:(SRHRace *)race {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.updatedContentSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[SRHNetworkRequests fetchStreamsForRace:race] subscribeNext:^(NSArray* streams) {
            self.raceStreams = streams;
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to access load race streams at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }];
    }];
    
    self.updateContentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return self.updatedContentSignal;
    }];
    
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        [self.updateContentCommand execute:nil];
    }];
    
    self.gameLabelText = [race.game.name uppercaseString];
    self.goalLabelText = race.goal;
    self.entrantsNumberLabelText = [NSString stringWithFormat:@"%d",[race.entrants count]];
    self.entrantsLabelText = [race.entrants count] == 1 ? @"entrant" : @"entrants";
    
    return self;
}

-(NSInteger)numberOfSections {
    return 1;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.raceStreams count];
}

-(SRHStream *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.raceStreams[indexPath.item];
}

-(SRHRaceStreamCellViewModel *)viewModelForItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStream *stream = self.raceStreams[indexPath.item];
    
    return [[SRHRaceStreamCellViewModel alloc] initWithStream:stream];
}

@end
