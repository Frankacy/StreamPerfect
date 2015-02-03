//
//  SRHStreamsCollectionHeader.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const SRHStreamCollectionViewHeader;

@class SRHStreamsSectionViewModel;

@interface SRHStreamsCollectionHeader : UICollectionReusableView

@property(nonatomic, strong) SRHStreamsSectionViewModel *viewModel;

@end
