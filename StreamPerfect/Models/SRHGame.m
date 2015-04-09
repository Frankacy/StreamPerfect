//
//  SRHGame.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHGame.h"
#import "NSString+URLEncode.h"

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

- (void)getArtworkURLWithCompletion:(void(^)(NSURL *artworkURL))completion {
    NSString *blandGameName = [self.name stringByReplacingOccurrencesOfString:@" (PC)" withString:@""];
    NSString *safeGameName = [blandGameName URLEncode];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.giantbomb.com/search/?api_key=1876a513878592d6929436aff3b97778cfaf109d&query=%@&field_list=name,image&format=json",safeGameName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSURL *boxArtURL = [NSURL URLWithString:[self parseBoxArtJson:JSON]];
                                                                                            completion(boxArtURL);
                                                                                        }
                                                                                        failure:nil];
    [operation start];
}

- (NSString *)parseBoxArtJson:(id)JSON
{
    NSString* boxArtUrl = @"";
    
    if([JSON isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* results = (NSDictionary *)JSON;
        if ([[results objectForKey:@"number_of_total_results"] integerValue] > 0)
        {
            if([[[[results objectForKey:@"results"] objectAtIndex:0] objectForKey:@"image"] valueForKey:@"icon_url"] != [NSNull null])
            {
                boxArtUrl = [[[[results objectForKey:@"results"] objectAtIndex:0] objectForKey:@"image"] valueForKey:@"icon_url"];
            }
        }
    }
    
    return boxArtUrl;
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
