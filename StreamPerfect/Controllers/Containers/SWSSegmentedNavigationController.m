//
//  SWSSegmentedNavigationController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SWSSegmentedNavigationController.h"
#import "UIImage+IconAndTextHeader.h"
#import "UIImage+SRHImageFromColor.h"
#import "UIColor+SRHColors.h"
#import "CCBSegmentedControl.h"

@interface SWSSegmentedNavigationController () <UINavigationBarDelegate>

@property(nonatomic, strong) NSArray *segmentViewControllers;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *images;

@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, strong) CCBSegmentedControl *navigationSegmentedControl;

@end

@implementation SWSSegmentedNavigationController

-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    return [[SWSSegmentedNavigationController alloc] initWithSegmentViewControllers:viewControllers titles:titles images:nil];
}

-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers images:(NSArray *)images {
    return [[SWSSegmentedNavigationController alloc] initWithSegmentViewControllers:viewControllers titles:nil images:images];
}

-(instancetype)initWithSegmentViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles images:(NSArray *)images {
    self = [super init];
    if (self) {
        self.segmentViewControllers = viewControllers;
        self.titles = titles;
        self.images = images;
    }
    
    return self;
}

- (CCBSegmentedControl *)segmentedControl {
    NSArray *images = @[ [UIImage imageNamed:@"camera"],
                         [UIImage imageNamed:@"timer"]];

    NSArray *selectedImages = @[ [UIImage imageNamed:@"camera_selected"],
                                 [UIImage imageNamed:@"timer_selected"]];
    
    CCBSegmentedControl *segmentedControl = [[CCBSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages titlesForSections:@[ @"STREAMS", @"RACES" ]];
    segmentedControl.frame = CGRectMake(0, 0, 0, 44);
    segmentedControl.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.textColor = [UIColor srhBlueGrayColor];
    segmentedControl.selectedTextColor = [UIColor srhPurpleColor];
    segmentedControl.selectionIndicatorHeight = 10.0;
    segmentedControl.selectionIndicatorWidth = 19.0;
    segmentedControl.selectionIndicatorColor = [UIColor srhPurpleColor];
    
    return segmentedControl;
}

- (UISegmentedControl *)loadNavigationSegmentedControl {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] init];
    
    for (int i = 0; i < self.segmentViewControllers.count; i++) {
        if (self.images && self.titles) {
            [segmentedControl insertSegmentWithImage:[UIImage imageFromImage:self.images[i] string:self.titles[i] color:[UIColor blackColor] font:[UIFont fontWithName:@"AdelleSans-Light" size:15.0]]
                                             atIndex:i animated:NO];
        } else if (self.images) {
            [segmentedControl insertSegmentWithImage:self.images[i] atIndex:i animated:NO];
        } else {
            [segmentedControl insertSegmentWithTitle:self.titles[i] atIndex:i animated:NO];
        }
    }
    
    segmentedControl.tintColor = [UIColor blackColor];
    [segmentedControl setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(200, 44)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    segmentedControl.frame = CGRectMake(0, 0, [segmentedControl intrinsicContentSize].width, [segmentedControl intrinsicContentSize].height);
    
    return segmentedControl;
}

- (void)segmentSelected:(CCBSegmentedControl *)segmentedControl {
    //Delegate.WillSwitchViewControllers
    
    self.selectedIndex = segmentedControl.selectedSegmentIndex;
    UIViewController *controllerToShow = self.segmentViewControllers[self.selectedIndex];
    controllerToShow.navigationItem.titleView = self.navigationSegmentedControl;
    
    self.viewControllers = @[ controllerToShow ];
    
    //Delegate.DidSwitchViewControllers
}

- (void)loadView {
    [super loadView];
    
    if (!self.navigationSegmentedControl) {
        self.navigationSegmentedControl =  [self segmentedControl]; //[self loadNavigationSegmentedControl];
        [self.navigationSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationSegmentedControl setSelectedSegmentIndex:0];
    [self segmentSelected:self.navigationSegmentedControl];
}

@end
