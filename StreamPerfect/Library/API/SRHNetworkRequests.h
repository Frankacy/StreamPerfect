//
//  SRHNetworkRequests.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class SRHRace;

@interface SRHNetworkRequests : NSObject

+ (RACSignal *)fetchStreams;

+ (RACSignal *)fetchRaces;

+ (RACSignal *)fetchStreamsForRace:(SRHRace *)race;

@end
