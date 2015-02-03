//
//  SRHRaceStreamsHeader.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-15.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const SRHRaceStreamsCollectionViewHeader;

@class SRHRaceStreamsViewModel;

@interface SRHRaceStreamsHeader : UICollectionReusableView

@property(nonatomic, strong) SRHRaceStreamsViewModel *viewModel;

@end
