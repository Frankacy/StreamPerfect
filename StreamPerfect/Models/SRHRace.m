//
//  SRHRace.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRace.h"
#import "SRHStreamer.h"
#import "SRHGame.h"

#import <RestKit/RestKit.h>

@implementation SRHRace

+ (RKObjectMapping *)objectMappingForSRLAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHRace class]];
    RKObjectMapping *streamerMapping = [SRHStreamer objectMappingForSRLAPI];
    RKObjectMapping *gameMapping = [SRHGame objectMappingForSRLAPI];
    
    streamerMapping.forceCollectionMapping = YES;
    [streamerMapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"SRLName"];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"SRLIdentifier",
                                                   @"goal" : @"goal",
                                                   @"state" : @"state" }];
    
    RKValueTransformer *elapsedTimeValueTransformer = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass, __unsafe_unretained Class outputValueClass) {
        return inputValueClass == [NSNumber class] && outputValueClass == [NSNumber class];
    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
        NSTimeInterval elapsedTime = [(NSNumber *)inputValue doubleValue];
        if (elapsedTime > 0) {
            *outputValue = @([[NSDate date] timeIntervalSince1970] - elapsedTime);
        } else {
            *outputValue = @0;
        }
        
        return true;
    }];
    
    RKAttributeMapping *elapsedTimeMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"time" toKeyPath:@"elapsedTime"];
    elapsedTimeMapping.valueTransformer = elapsedTimeValueTransformer;
    
    [mapping addAttributeMappingsFromArray:@[elapsedTimeMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"entrants" mapping:streamerMapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"game" mapping:gameMapping];
    
    return mapping;
}

+ (NSString *)raceStateToString:(SRHRaceState)raceState {
    NSString *result = nil;
    
    switch (raceState) {
        case SRHRaceStateEntryOpen:
            result = @"Entry Open";
            break;
        case SRHRaceStateReady:
            result = @"Ready";
            break;
        case SRHRaceStateInProgress:
            result = @"In Progress";
            break;
        case SRHRaceStateCompleted:
        case SRHRaceStateRaceOver:
            result = @"Completed";
            break;
        default:
            break;
    }
    
    return result;
}

+ (NSString *)raceStateToIconName:(SRHRaceState)raceState {
    NSString *result = nil;
    
    switch (raceState) {
        case SRHRaceStateEntryOpen:
            result = @"entry_open";
            break;
        case SRHRaceStateReady:
            result = @"ready";
            break;
        case SRHRaceStateInProgress:
            result = @"in_progress";
            break;
        case SRHRaceStateCompleted:
        case SRHRaceStateRaceOver:
            result = @"completed";
            break;
        default:
            break;
    }
    
    return result;
}

@end
