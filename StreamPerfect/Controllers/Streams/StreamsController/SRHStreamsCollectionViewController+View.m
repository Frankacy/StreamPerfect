//
//  SRHStreamsCollectionViewController+View.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SRHStreamsViewModel.h"
#import "UIColor+SRHColors.h"
#import "SRHStreamsCollectionViewController+View.h"

@implementation SRHStreamsCollectionViewController (View)

- (void)loadView {
    [super loadView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor srhPurpleColor];
    refreshControl.rac_command = self.viewModel.updateContentCommand;
    [self.collectionView addSubview:refreshControl];
}

@end
