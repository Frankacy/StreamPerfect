//
//  SRHStreamsViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsViewModel.h"
#import "SRHStreamsSectionViewModel.h"
#import "SRHNetworkRequests.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RestKit/RestKit.h>
#import <ReactiveCocoa/RACEXTScope.h>

NSInteger const SRHFeaturedCellCount = 3;

@interface SRHStreamsViewModel ()

@property(nonatomic, strong) NSArray *sectionViewModels;
@property(nonatomic, strong) RACSignal *updatedContentSignal;
@property(nonatomic, strong) RACCommand *updateContentCommand;

@end

@implementation SRHStreamsViewModel

-(id)init {
    self = [super init];
    if (self) {
        
        @weakify(self);
        self.updatedContentSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return [[SRHNetworkRequests fetchStreams] subscribeNext:^(NSSet* streams) {
                NSSet *filteredStreams = [streams filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (title CONTAINS[cd] %@)", @"[nosrl]"]];
                [self createSectionViewModelsFromStreams:[filteredStreams allObjects]];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to access load streams at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
            }];
        }];
        
        self.updateContentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return self.updatedContentSignal;
        }];
        
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.updateContentCommand execute:nil];
        }];
    }
    
    return self;
}

-(void)createSectionViewModelsFromStreams:(NSArray *)streams {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"currentViewerCount" ascending:NO];
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"streamer.followerCount" ascending:NO];
    NSArray *sortedArray = [streams sortedArrayUsingDescriptors:@[descriptor]];
    
    SRHStreamsSectionViewModel *featuredViewModel = [[SRHStreamsSectionViewModel alloc] initWithStreams:[sortedArray subarrayWithRange:NSMakeRange(0, SRHFeaturedCellCount)]
                                                                                               andTitle:@"POPULAR"];
    SRHStreamsSectionViewModel *streamsViewModel = [[SRHStreamsSectionViewModel alloc] initWithStreams:[sortedArray subarrayWithRange:NSMakeRange(SRHFeaturedCellCount, sortedArray.count - SRHFeaturedCellCount)]
                                                                                              andTitle:@"LIVE STREAMS"];
    
    self.sectionViewModels = @[featuredViewModel, streamsViewModel];
}

#pragma mark - UICollectionView management

-(NSInteger)numberOfSections {
    return self.sectionViewModels.count;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    SRHStreamsSectionViewModel *viewModel = self.sectionViewModels[section];
    return viewModel.streams.count;
}

-(SRHStream *)itemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStreamsSectionViewModel *viewModel = self.sectionViewModels[indexPath.section];
    return viewModel.streams[indexPath.item];
}

-(NSString *)titleForSection:(NSInteger)section {
    SRHStreamsSectionViewModel *viewModel = self.sectionViewModels[section];
    return viewModel.headerTitle;
}

@end
