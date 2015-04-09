//
//  SRHStreamsCollectionViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsCollectionViewController.h"
#import "SRHStreamsViewModel.h"
#import "SRHStreamCellViewModel.h"
#import "SRHStreamDetailsViewModel.h"
#import "SRHStreamDetailsViewController.h"
#import "SRHStreamsCollectionHeader.h"
#import "SRHStreamCell.h"
#import "SRHStream.h"
#import "SRHStreamer.h"
#import "SRHStreamsCollectionLiveStreamsHeader.h"
#import "SRHMiniStreamCell.h"
#import "SRHStyleFactory.h"
#import "UIColor+SRHColors.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

NSString* const SRHStreamCellReuseIdentifier = @"SRHStreamCell";
NSString* const SRHMiniStreamCellReuseIdentifier = @"SRHMiniStreamCell";

@interface SRHStreamsCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SRHStreamsCollectionViewController

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout viewModel:(SRHStreamsViewModel *)viewModel {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _viewModel = viewModel;
    }

    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[SRHStreamCell class] forCellWithReuseIdentifier:SRHStreamCellReuseIdentifier];
    [self.collectionView registerClass:[SRHMiniStreamCell class] forCellWithReuseIdentifier:SRHMiniStreamCellReuseIdentifier];
    [self.collectionView registerClass:[SRHStreamsCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SRHStreamsPopularHeader"];
    [self.collectionView registerClass:[SRHStreamCollectionLiveStreamsHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SRHStreamsLiveStreamsHeader"];
    
    self.collectionView.backgroundColor = [UIColor srhLightGrayColor];
    self.navigationItem.title = @"Streams";
    
    @weakify(self);
    [[RACObserve(self.viewModel, sectionViewModels) filter:^BOOL(NSArray *sectionViewModels) {
        return sectionViewModels != nil;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Streams"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

#pragma mark - Flow layout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 30;
    } else if (section == 1) {
        return 25;
    }
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(25, 33, 20, 33);
    } else if (section == 1) {
        return UIEdgeInsetsMake(55, 19, 30, 19);
    }
    
    return UIEdgeInsetsZero;
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return CGSizeMake(350, 275);
        } else {
            return CGSizeMake(274, 215);
        }
    } else {
        return CGSizeMake(225, 176);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SRHStreamsCollectionHeader *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SRHStreamsPopularHeader" forIndexPath:indexPath];
        
        header.viewModel = self.viewModel.sectionViewModels[indexPath.section];
        
        return header;
    } else if (indexPath.section == 1) {
        SRHStreamCollectionLiveStreamsHeader *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SRHStreamsLiveStreamsHeader" forIndexPath:indexPath];
        
        header.viewModel = self.viewModel.sectionViewModels[indexPath.section];
        
        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStreamCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier: indexPath.section == 0 ?
                                                                                       SRHStreamCellReuseIdentifier :
                                                                                       SRHMiniStreamCellReuseIdentifier
                                                                         forIndexPath:indexPath];
    cell.stream = [self.viewModel itemAtIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStream *stream = [self.viewModel itemAtIndexPath:indexPath];
    SRHStreamDetailsViewModel *viewModel = [[SRHStreamDetailsViewModel alloc] initWithStream:stream];
    [self sendAnalyticsForStream:stream];
    
    [self.navigationController pushViewController:[[SRHStreamDetailsViewController alloc] initWithStream:stream]
                                         animated:YES];
}

- (void)sendAnalyticsForStream:(SRHStream *)stream {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Streams"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"Select Stream"
                                                           label:stream.streamer.name
                                                           value:nil] build]];
}

@end
