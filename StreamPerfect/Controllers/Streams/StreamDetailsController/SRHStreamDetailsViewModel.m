//
//  SRHStreamDetailsViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamDetailsViewModel.h"
#import "SRHAccountManager.h"
#import "SRHStream.h"
#import "SRHGame.h"
#import "SRHStreamer.h"

#import "UIColor+SRHColors.h"

@interface SRHStreamDetailsViewModel ()

@property(nonatomic, strong) SRHStream* stream;

@end

@implementation SRHStreamDetailsViewModel

-(instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (self) {
        _stream = stream;
        
        RAC(self, mainTitle) = [RACSignal combineLatest:@[ RACObserve(self, self.stream.streamer.name),
                                                          RACObserve(self, self.stream.game) ]
                                                 reduce:^id(NSString *streamerName, SRHGame *game){
                                                           NSMutableAttributedString *cellTitle = [[NSMutableAttributedString alloc] init];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamerName attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:24.0],
                                                                                                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing " attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:20.0],
                                                                                                                                                                    NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something"
                                                                                                                             attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Bold" size:22.0],
                                                                                                                                           NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
                                                           
                                                           return [cellTitle copy];
                                                 }];
        RAC(self, streamTitle) = RACObserve(self, self.stream.title);
        RAC(self, followersNumberText) = [RACObserve(self, self.stream.streamer.followerCount) map:^id(NSNumber *followerCount) {
            return [followerCount stringValue];
        }];
        RAC(self, followersTitleText) = [RACObserve(self, self.stream.streamer.followerCount) map:^id(NSNumber *followerCount) {
            return [followerCount isEqualToValue:@1] ? @"follower" : @"followers";
        }];
        RAC(self, viewersNumberText) = [RACObserve(self, self.stream.currentViewerCount) map:^id(NSNumber *viewerCount) {
            NSInteger i = [viewerCount integerValue] + 1;
            return [NSString stringWithFormat:@"%ld", (long)i];
        }];
        RAC(self, viewersTitleText) = [RACObserve(self, self.stream.currentViewerCount) map:^id(NSNumber *viewerCount) {
            return [viewerCount isEqualToValue:@1] ? @"viewer" : @"viewers";
        }];
        
        
        RAC(self, avatarURL) = RACObserve(self, self.stream.streamer.avatarURL);
        RAC(self, twitchScreenName) = RACObserve(self, self.stream.streamer.name);
        
//        _followCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            SRHAccountManager *accountManager = [SRHAccountManager sharedManager];
//            if (accountManager.isLoggedIn) {
//                
//            } else {
//                return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                    [subscriber sendNext:@""];
//                    return nil;
//                }] subscribeNext:^(id x) {
//                    
//                }
//            }
//        }];
        
        _shouldKillStream = NO;
    }
    
    return self;
}

@end
