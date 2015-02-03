//
//  SRHRaceCellViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-30.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceCellViewModel.h"
#import "SRHRace.h"
#import "SRHGame.h"
#import "NSString+URLEncode.h"

#import <RestKit/RestKit.h>

@interface SRHRaceCellViewModel ()

@property(nonatomic, strong) NSURL *gameImageURL;
@property(nonatomic, strong) NSString *goalText;
@property(nonatomic, strong) NSString *gameTitle;

@end

@implementation SRHRaceCellViewModel

- (instancetype)initWithRace:(SRHRace *)race {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _race = race;
    
    RAC(self, goalText) = RACObserve(self, self.race.goal);
    RAC(self, gameTitle) = [RACObserve(self, self.race.game) map:^id(SRHGame *game) {
        return [[game shortName] uppercaseString];
    }];
    RAC(self, gameImageURL) = RACObserve(self, self.race.game.boxArtURL);
    
    if (!race.game.boxArtURL) {
        [self setArtworkUrlForGame:race.game];
    }
    
    return self;
}

- (void)setArtworkUrlForGame:(SRHGame *)game
{
    NSString *blandGameName = [game.name stringByReplacingOccurrencesOfString:@" (PC)" withString:@""];
    NSString *safeGameName = [blandGameName URLEncode];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.giantbomb.com/search/?api_key=1876a513878592d6929436aff3b97778cfaf109d&query=%@&field_list=name,image&format=json",safeGameName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            game.boxArtURL = [NSURL URLWithString:[self parseBoxArtJson:JSON]];
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


@end
