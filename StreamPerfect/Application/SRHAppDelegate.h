//
//  SRHAppDelegate.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-26.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKObjectManager;

@interface SRHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) RKObjectManager *SRLAPIManager;
@property (nonatomic, strong) RKObjectManager *TwitchAPIManager;
@property (nonatomic, strong) RKObjectManager *TwitchTeamAPIManager;

@end