//
//  SRHNetworkRequests.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHNetworkRequests.h"
#import "SRHAppDelegate.h"
#import "SRHRace.h"
#import <RestKit/RestKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

@implementation SRHNetworkRequests

+ (RACSignal *)fetchStreams {
    NSArray *teamNames = @[ @"srl", @"sda", @"thecollective", @"ludendi", @"wobblers", @"fastforce", @"hotarubi", @"goonies", @"hayaikawaii", @"wolfpack", @"srlol", @"mylzh", @"psr" ];
    
    NSMutableArray *signalArray = [NSMutableArray array];
    
    for (NSString *team in teamNames) {
        [signalArray addObject:[SRHNetworkRequests signalForLiveStreamsFromTeam:team]];
    }
    
    return [[RACSignal combineLatest:signalArray ]
                                 map:^id(RACTuple *tuple){
                                     //Removes stream duplicates
                                     NSSet *streamSet = [[NSSet setWithArray:[tuple allObjects]] valueForKeyPath:@"@distinctUnionOfSets.self"];
                                     
                                     return streamSet;
                                 }];
}

+ (RACSignal *)signalForLiveStreamsFromTeam:(NSString *)team {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SRHAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        RKObjectManager* objectManager = [delegate TwitchTeamAPIManager];
        [objectManager getObjectsAtPath:[NSString stringWithFormat:@"api/team/%@/live_channels.json", team]
                             parameters:nil
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    [subscriber sendNext:mappingResult.set];
                                    [subscriber sendCompleted];
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error when loading streams: %@", error);
                                    [subscriber sendCompleted];
                                }];
        return nil;
    }];
}

+ (RACSignal *)fetchRaces {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SRHAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
        RKObjectManager* objectManager = [delegate SRLAPIManager];
        [objectManager getObjectsAtPath:@"races" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult.array];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error when loading streams: %@", error);
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

+ (RACSignal *)fetchStreamsForStreamers:(NSArray *)streamers {
    NSString *streamersToFetch = [[streamers valueForKey:@"name"] componentsJoinedByString:@","];
    if ([streamersToFetch length] == 0) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@[]];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SRHAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        NSDictionary *params = @{ @"channel" : streamersToFetch };
    
        RKObjectManager* objectManager = [delegate TwitchAPIManager];
        [objectManager getObjectsAtPath:@"kraken/streams" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult.array];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error when loading streams: %@", error);
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

+ (RACSignal *)fetchStreamsForRace:(SRHRace *)race {
    return [SRHNetworkRequests fetchStreamsForStreamers:race.entrants];
}

+ (RACSignal *)fetchFollowedStreamsForUserWithToken:(NSString *)token {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLRequest *followedStreamsRequest = [self requestForFollowedStreamsWithToken:token];
        AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:followedStreamsRequest];
        [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        [request start];
        return nil;
    }];
}

+ (NSURLRequest *)requestForFollowedStreamsWithToken:(NSString *)token {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitch.tv/kraken/streams/followed"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/vnd.twitchtv.v2+json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"OAuth %@", token] forHTTPHeaderField:@"Authorization"];
    
    return [request copy];
}

@end
