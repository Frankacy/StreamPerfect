//
//  SRHTwitchUser.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface SRHTwitchUser : NSObject

@property(nonatomic, strong) NSString *displayName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *authenticationToken;
@property(nonatomic, strong) NSURL *photoURL;
@property(nonatomic, assign, getter = isPartnered) BOOL partnered;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSArray *followedStreamNames;

@property(nonatomic, assign) BOOL hasFetchedDetails;

+ (RKObjectMapping *)mappingForTwitchAPI;

@end
