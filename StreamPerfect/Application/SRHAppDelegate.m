//
//  SRHAppDelegate.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-26.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHAppDelegate.h"
#import "SRHMasterContainerViewController.h"

#import "SRHRestKitConfigurator.h"
#import "SWSSegmentedNavigationController.h"
#import "SRHStreamsCollectionViewController.h"
#import "SRHStreamsViewModel.h"

#import "SRHRacesViewModel.h"
#import "SRHRacesTableViewController.h"

#import <CocoaPods-Keys/StreamPerfectKeys.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>

@interface SRHAppDelegate ()

@property(nonatomic, strong) UINavigationController *navigationController;

@end

@implementation SRHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self setupAnalytics];
    
    self.TwitchAPIManager = [SRHRestKitConfigurator objectManagerForTwitchAPI];
    self.SRLAPIManager = [SRHRestKitConfigurator objectManagerForSRLAPI];
    self.TwitchTeamAPIManager = [SRHRestKitConfigurator objectManagerForTwitchTeamAPI];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:16.0] } forState:UIControlStateNormal];
    
    SRHMasterContainerViewController *controller = [[SRHMasterContainerViewController alloc] init];
    self.window.rootViewController = controller;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:[[[StreamPerfectKeys alloc] init] googleAnalyticsID]];
}

@end
