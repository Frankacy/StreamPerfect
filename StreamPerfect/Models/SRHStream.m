//
//  SRHStream.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStream.h"
#import "SRHGame.h"
#import "SRHStreamer.h"

#import <RestKit/RestKit.h>

@implementation SRHStream

-(NSURL *)currentThumbnail {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://static-cdn.jtvnw.net/previews-ttv/live_user_%@-320x200.jpg", [self.streamer.name lowercaseString]]];
}


+ (RKObjectMapping *)objectMappingForTwitchAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStream class]];
    RKObjectMapping *gameMapping = [SRHGame objectMappingForTwitchAPI];
    RKObjectMapping *streamerMapping = [SRHStreamer objectMappingForTwitchAPI];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"channel.status" : @"title",
                                                   @"viewers" : @"currentViewerCount" }];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel" toKeyPath:@"game" withMapping:gameMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel" toKeyPath:@"streamer" withMapping:streamerMapping]];
    
    return mapping;
}

+ (RKObjectMapping *)objectMappingForTwitchTeamAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStream class]];
    RKObjectMapping *gameMapping = [SRHGame objectMappingForTwitchTeamAPI];
    RKObjectMapping *streamerMapping = [SRHStreamer objectMappingForTwitchTeamAPI];

    [mapping addAttributeMappingsFromDictionary:@{ @"channel.title" : @"title",
                                                   @"channel.current_viewers" : @"currentViewerCount" }];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel" toKeyPath:@"game" withMapping:gameMapping]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channel" toKeyPath:@"streamer" withMapping:streamerMapping]];
    
    return mapping;
}

+ (RKObjectMapping *)objectMappingForSRLAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHStream class]];

    [mapping addAttributeMappingsFromDictionary:@{}];
    
    return mapping;
}

- (BOOL)isEqualToStream:(SRHStream *)stream {
    return ([self.game.name isEqualToString:stream.game.name]
            && [self.streamer.name isEqualToString:stream.streamer.name]
            && [self.title isEqualToString:stream.title]);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SRHStream class]]) {
        return NO;
    }
    
    return [self isEqualToStream:(SRHStream *)object];
}

- (NSUInteger)hash {
    return [self.title hash] ^ [self.streamer.name hash] ^ [self.game.name hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Stream title: %@\ncurrent thumbnail: %@\nviewer count: %d\ngame: %@\n streamer: %@",
            self.title,
            self.currentThumbnail,
            self.currentViewerCount,
            self.game,
            self.streamer];
}

@end
