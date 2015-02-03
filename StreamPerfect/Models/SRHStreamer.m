//
//  SRHStreamer.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamer.h"
#import <RestKit/RestKit.h>

@implementation SRHStreamer

+ (RKObjectMapping *)objectMappingForTwitchAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStreamer class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"display_name" : @"name",
                                                   @"followers" : @"followerCount",
                                                   @"views" : @"totalViews",
                                                   @"logo" : @"avatarURL" }];
    
    return mapping;
}

+ (RKObjectMapping *)objectMappingForTwitchTeamAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStreamer class]];

    [mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name",
                                                   @"followers_count" : @"followerCount",
                                                   @"total_views" : @"totalViews",
                                                   @"image.size300" : @"avatarURL" }];

    return mapping;
}

+ (RKObjectMapping *)objectMappingForSRLAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStreamer class]];

    [mapping addAttributeMappingsFromDictionary:@{ @"(SRLName).twitch" : @"name" }];
    
    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@\nSRLName: %@\nfollowerCount: %d\nTotalViews: %d\nAvatarURL: %@", self.name, self.SRLName, self.followerCount, self.totalViews, self.avatarURL];
}

@end
