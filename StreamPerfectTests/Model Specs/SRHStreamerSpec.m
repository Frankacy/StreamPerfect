//
//  SRHStreamerSpec.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-25.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHTestHelpers.h"

#import <RestKit/RestKit.h>
#import "SRHStreamer.h"

SpecBegin(SRHStreamer)

describe(@"SRHStreamer class methods", ^{
    it(@"should provide correct mappings for Twitch Teams API", ^{
        RKObjectMapping *mapping = [SRHStreamer objectMappingForTwitchTeamAPI];
        
        expect(mapping).toNot.beNil();
        expect([mapping mappingForSourceKeyPath:@"name"]).toNot.beNil();
        expect([mapping mappingForSourceKeyPath:@"followers_count"]).toNot.beNil();
        expect([mapping mappingForSourceKeyPath:@"total_views"]).toNot.beNil();
        expect([mapping mappingForSourceKeyPath:@"image.size300"]).toNot.beNil();
    });
    
    it(@"should provide correct mappings for SRL API", ^{
        RKObjectMapping *mapping = [SRHStreamer objectMappingForSRLAPI];
        
        expect(mapping).toNot.beNil();
        expect([mapping mappingForSourceKeyPath:@"displayname"]).toNot.beNil();
    
    });
    
    pending(@"should provide correct mappings for Twitch API", ^{
    
    });
});

SpecEnd