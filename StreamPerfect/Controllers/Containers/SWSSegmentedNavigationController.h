//
//  SWSSegmentedNavigationController.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCBSegmentedControl;

@interface SWSSegmentedNavigationController : UINavigationController

@property(nonatomic, strong, readonly) NSArray *segmentViewControllers;
@property(nonatomic, strong, readonly) CCBSegmentedControl *navigationSegmentedControl;
@property(nonatomic, assign, readonly) NSUInteger selectedIndex;

-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers images:(NSArray *)images;
-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles images:(NSArray *)images;

@end
