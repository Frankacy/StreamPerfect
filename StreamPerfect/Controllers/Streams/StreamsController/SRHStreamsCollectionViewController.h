//
//  SRHStreamsCollectionViewController.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRHStreamsViewModel;

@interface SRHStreamsCollectionViewController : UICollectionViewController

@property(nonatomic, strong) SRHStreamsViewModel *viewModel;

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout viewModel:(SRHStreamsViewModel *)viewModel;

@end
