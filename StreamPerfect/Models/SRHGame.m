//
//  SRHGame.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHGame.h"
#import <RestKit/RestKit.h>

@implementation SRHGame

- (NSString *)shortName {
    if ([self.name rangeOfString:@"The Legend Of Zelda" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return [self.name stringByReplacingOccurrencesOfString:@"The Legend Of Zelda" withString:@"TLOZ" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self.name length])];
    }
//    else if ([self.name rangeOfString:@"Pokemon" options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch].location != NSNotFound) {
//        return [self.name stringByReplacingOccurrencesOfString:@"Pokemon" withString:@"PKMN"];
//    }
    else if ([self.name rangeOfString:@"Castlevania" options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch].location != NSNotFound) {
        return [self.name stringByReplacingOccurrencesOfString:@"Castlevania" withString:@"CV"];
    }
    else if ([self.name rangeOfString:@"Grand Theft Auto" options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch].location != NSNotFound) {
        return [self.name stringByReplacingOccurrencesOfString:@"Grand Theft Auto" withString:@"GTA"];
    }
    
    return self.name;
}

+ (RKObjectMapping *)objectMappingForTwitchAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHGame class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"game" : @"name" }];
    
    return mapping;
}

+ (RKObjectMapping *)objectMappingForTwitchTeamAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHGame class]];

    [mapping addAttributeMappingsFromDictionary:@{ @"meta_game" : @"name" }];
    
    return mapping;
}

+ (RKObjectMapping *)objectMappingForSRLAPI {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SRHGame class]];

    [mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name",
                                                   @"abbrev" : @"SRLAbbreviation",
                                                   @"id" : @"SRLIdentifier",
                                                   @"popularityrank" : @"SRLPopularityRank" }];
    
    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@\nabbreviation: %@\nsrlid: %d\nPopularityRank: %d\n", self.name, self.SRLAbbreviation, self.SRLIdentifier , self.SRLPopularityRank];
}

@end
