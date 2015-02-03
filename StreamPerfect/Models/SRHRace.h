//
//  SRHRace.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@class SRHGame;

typedef NS_ENUM(NSUInteger, SRHRaceState) {
    SRHRaceStateEntryOpen = 1,
    SRHRaceStateReady = 2,
    SRHRaceStateInProgress = 3,
    SRHRaceStateCompleted = 4,
    SRHRaceStateRaceOver = 5
};

@interface SRHRace : NSObject

@property(nonatomic, strong) NSString *SRLIdentifier;
@property(nonatomic, strong) NSString *goal;
@property(nonatomic, strong) SRHGame *game;
@property(nonatomic, strong) NSArray *entrants; //Contains SRHStreamers
@property(nonatomic, assign) NSTimeInterval elapsedTime;
@property(nonatomic, assign) SRHRaceState state;

+ (RKObjectMapping *)objectMappingForSRLAPI;

+ (NSString *)raceStateToString:(SRHRaceState)raceState;
+ (NSString *)raceStateToIconName:(SRHRaceState)raceState;

@end
