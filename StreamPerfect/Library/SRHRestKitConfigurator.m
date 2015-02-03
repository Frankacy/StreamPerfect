//
//  SRHRestKitConfigurator.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRestKitConfigurator.h"
#import <RestKit/RestKit.h>
#import "Models.h"

@implementation SRHRestKitConfigurator

+ (RKObjectManager *)objectManagerForTwitchAPI {
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.twitch.tv/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:@"application/vnd.twitchtv.v2+json"];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup our object mappings
    RKObjectMapping *streamMapping = [SRHStream objectMappingForTwitchAPI];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *raceStreamsResponse = [RKResponseDescriptor responseDescriptorWithMapping:streamMapping
                                                                                         method:RKRequestMethodGET
                                                                                    pathPattern:@"kraken/streams"
                                                                                        keyPath:@"streams"
                                                                                    statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:raceStreamsResponse];
    
    return objectManager;
}

+ (RKObjectManager *)objectManagerForTwitchTeamAPI {
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://api.twitch.tv/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup our object mappings
    RKObjectMapping *streamMapping = [SRHStream objectMappingForTwitchTeamAPI];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:streamMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"api/team/:team/live_channels.json"
                                                                                           keyPath:@"channels"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];

    return objectManager;
}

+ (RKObjectManager *)objectManagerForSRLAPI {
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://api.speedrunslive.com/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Setup our object mappings
    RKObjectMapping *raceMapping = [SRHRace objectMappingForSRLAPI];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:raceMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"races"
                                                                                           keyPath:@"races"
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    return objectManager;
}

@end
