//
//  SRHRaceStreamsCollectionController.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-30.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRHRaceStreamsViewModel;

@interface SRHRaceStreamsCollectionController : UICollectionViewController

@property(nonatomic, strong) SRHRaceStreamsViewModel *viewModel;

-(id)initWithViewModel:(SRHRaceStreamsViewModel *)viewModel;

@end
