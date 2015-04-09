//
//  SRHRaceStreamsCollectionController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-30.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceStreamsCollectionController.h"
#import "SRHRaceStreamsViewModel.h"
#import "SRHStreamDetailsViewModel.h"
#import "SRHStreamDetailsViewController.h"
#import "SRHRaceStreamsHeader.h"
#import "UIColor+SRHColors.h"
#import "SRHRaceStreamCell.h"
#import "SRHStream.h"
#import "SRHStreamer.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

NSString* const SRHRaceStreamCellReuseIdentifier = @"SRHRaceStreamCell";

@interface SRHRaceStreamsCollectionController () <UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UILabel *emptyViewLabel;

@end

@implementation SRHRaceStreamsCollectionController

-(id)initWithViewModel:(SRHRaceStreamsViewModel *)viewModel {
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (!self) {
        return nil;
    }
    
    _viewModel = viewModel;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor srhLightGrayColor];
    
    [self.collectionView registerClass:[SRHRaceStreamCell class] forCellWithReuseIdentifier:SRHRaceStreamCellReuseIdentifier];
    [self.collectionView registerClass:[SRHRaceStreamsHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SRHRaceStreamsCollectionViewHeader];
    
    self.emptyViewLabel = [[UILabel alloc] initWithFrame:self.collectionView.frame];
    self.emptyViewLabel.text = @"No one seems to be streaming this race right now.";
    self.emptyViewLabel.textColor = [UIColor srhGrayTextColor];
    self.emptyViewLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    self.emptyViewLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyViewLabel.hidden = YES;
    [self.view addSubview:self.emptyViewLabel];
    [self.emptyViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.emptyViewLabel.superview);
    }];
    
//    [self.viewModel.updatedContentSignal subscribeCompleted:^{
//        @strongify(self);
//        if ([self.viewModel numberOfItemsInSection:0] == 0) {
//            //Setup empty view
//            self.collectionView.backgroundColor = [UIColor blueColor];
//        } else {
//            //Hide empty view
//            self.collectionView.backgroundColor = [UIColor srhLightGrayColor];
//            [self.collectionView reloadData];
//        }
//    }];
}

- (void)setViewModel:(SRHRaceStreamsViewModel *)viewModel {
    _viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(self.viewModel, raceStreams) subscribeNext:^(id x) {
    }];
    
    [self.viewModel.updatedContentSignal subscribeCompleted:^{
        @strongify(self);
        if ([self.viewModel numberOfItemsInSection:0] == 0) {
            //Setup empty view
            self.emptyViewLabel.hidden = NO;
        } else {
            //Hide empty view
            self.emptyViewLabel.hidden = YES;
        }
        
        [self.collectionView reloadData];
    }];
}

#pragma mark - Collection View

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 38;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 61);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(195, 154);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(45, 25, 25, 25);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SRHRaceStreamsHeader *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SRHRaceStreamsCollectionViewHeader forIndexPath:indexPath];
    
    headerView.viewModel = self.viewModel;
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStream *stream = [self.viewModel itemAtIndexPath:indexPath];
    
    SRHRaceStreamCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:SRHRaceStreamCellReuseIdentifier
                                                                             forIndexPath:indexPath];
    cell.stream = stream;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SRHStream *stream = [self.viewModel itemAtIndexPath:indexPath];
    SRHStreamDetailsViewModel *viewModel = [[SRHStreamDetailsViewModel alloc] initWithStream:stream];
    [self sendAnalyticsForRaceStream:stream];
    
    [self.navigationController pushViewController:[[SRHStreamDetailsViewController alloc] initWithStream:stream]
                                         animated:YES];
}

- (void)sendAnalyticsForRaceStream:(SRHStream *)stream {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Race Streams"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"Select Race Stream"
                                                           label:stream.streamer.name
                                                           value:nil] build]];
}

@end
