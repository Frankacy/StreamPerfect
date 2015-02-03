//
//  SRHStream.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SRHStreamFollowStatus) {
    SRHStreamFollowStatusUnknown,
    SRHStreamFollowStatusLoading,
    SRHStreamFollowStatusNotFollowed,
    SRHStreamFollowStatusFollowed
};

@class SRHGame;
@class SRHStreamer;
@class RKObjectMapping;

@interface SRHStream : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) SRHGame *game;
@property(nonatomic, strong) SRHStreamer *streamer;
@property(nonatomic, strong) NSURL *currentThumbnail;

@property(nonatomic, assign) NSInteger currentViewerCount;
@property(nonatomic, assign, getter = isStreaming) BOOL streaming;

@property(nonatomic, assign) BOOL hasFetchedDetails;

+ (RKObjectMapping *)objectMappingForTwitchAPI;
+ (RKObjectMapping *)objectMappingForTwitchTeamAPI;
+ (RKObjectMapping *)objectMappingForSRLAPI;

@end
