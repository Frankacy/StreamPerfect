//
//  SRHMasterContainerViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHMasterContainerViewController.h"
#import "SRHStreamsViewModel.h"
#import "SRHStreamsCollectionViewController.h"
#import "SRHRacesViewModel.h"
#import "SRHRacesSplitViewController.h"
#import "SRHStreamsCollectionFlowLayout.h"
#import "SRHTwitchLoginViewController.h"
#import "UIColor+SRHColors.h"

#import "SWSSegmentedNavigationController.h"

@interface SRHMasterContainerViewController () <UINavigationControllerDelegate>

@end

@implementation SRHMasterContainerViewController

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    SRHStreamsViewModel *viewModel = [[SRHStreamsViewModel alloc] init];
    
    UICollectionViewFlowLayout *flowLayout = [[SRHStreamsCollectionFlowLayout alloc] init];
    SRHStreamsCollectionViewController *streamCollection = [[SRHStreamsCollectionViewController alloc] initWithCollectionViewLayout:flowLayout viewModel:viewModel];
    
    SRHRacesViewModel *racesViewModel = [[SRHRacesViewModel alloc] init];
    SRHRacesSplitViewController *racesSplitController = [[SRHRacesSplitViewController alloc] initWithViewModel:racesViewModel];
    
    UINavigationController *navigationController = [[SWSSegmentedNavigationController alloc] initWithSegmentViewControllers:@[streamCollection, racesSplitController]
                                                                                                                     titles:@[ @"STREAMS", @"RACES" ]
                                                                                                                     images:@[ [UIImage imageNamed:@"video"],
                                                                                                                               [UIImage imageNamed:@"stopwatch"]]];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_background"] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    navigationController.navigationBar.tintColor = [UIColor srhPurpleColor];
    navigationController.delegate = self;
    navigationController.navigationBar.backIndicatorImage = [[UIImage imageNamed:@"back_arrow"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_arrow_clipping_mask"];
    
    [self addControllerToHierarchy:navigationController];
    
    return self;
}

- (void)addControllerToHierarchy:(UIViewController *)controller {
    [self addChildViewController:controller];
    controller.view.frame = self.view.frame;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PH25"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSettingsToggle)];
}

- (void)handleSettingsToggle {
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    UIViewController *twitchLogin = [[SRHTwitchLoginViewController alloc] init];
    UIViewController *navController = [[UINavigationController alloc] initWithRootViewController:twitchLogin];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    
//    [self presentViewController:[self settingsController] animated:YES completion:^{
//    }];
}

- (void)handleCloseSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
