//
//  SRHGame.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface SRHGame : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *SRLAbbreviation;
@property(nonatomic, strong) NSURL* boxArtURL;
@property(nonatomic, assign) NSInteger SRLIdentifier;
@property(nonatomic, assign) NSInteger SRLPopularityRank;

- (NSString *)shortName;
- (void)getArtworkURLWithCompletion:(void(^)(NSURL *artworkURL))completion;

+ (RKObjectMapping *)objectMappingForTwitchAPI;
+ (RKObjectMapping *)objectMappingForTwitchTeamAPI;
+ (RKObjectMapping *)objectMappingForSRLAPI;

@end
