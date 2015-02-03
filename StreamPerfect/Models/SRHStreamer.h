//
//  SRHStreamer.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface SRHStreamer : NSObject

@property(nonatomic, strong) NSString *name; //Twitch name
@property(nonatomic, strong) NSString *SRLName;
@property(nonatomic, assign) NSInteger followerCount;
@property(nonatomic, assign) NSInteger totalViews;
@property(nonatomic, strong) NSURL *avatarURL;

+ (RKObjectMapping *)objectMappingForTwitchAPI;
+ (RKObjectMapping *)objectMappingForTwitchTeamAPI;
+ (RKObjectMapping *)objectMappingForSRLAPI;

@end
