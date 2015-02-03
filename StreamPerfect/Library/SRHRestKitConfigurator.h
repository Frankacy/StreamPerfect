//
//  SRHRestKitConfigurator.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectManager;

@interface SRHRestKitConfigurator : NSObject

+ (RKObjectManager *)objectManagerForTwitchAPI;
+ (RKObjectManager *)objectManagerForTwitchTeamAPI;
+ (RKObjectManager *)objectManagerForSRLAPI;

@end
