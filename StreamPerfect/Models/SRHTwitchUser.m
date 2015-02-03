//
//  SRHTwitchUser.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHTwitchUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RestKit/RestKit.h>

@implementation SRHTwitchUser

+ (RKObjectMapping *)mappingForTwitchAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHTwitchUser class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name",
                                                   @"display_name" : @"displayName",
                                                   @"logo" : @"photoURL",
                                                   @"partnered" : @"partnered",
                                                   @"email" : @"email"}];
    
    return mapping;
}

- (RACSignal *)fetchFollowedStreams {
    return [[RACSignal alloc] init];
}

- (RACSignal *)fetchUserDetails {
    return [[RACSignal alloc] init];
}

@end
