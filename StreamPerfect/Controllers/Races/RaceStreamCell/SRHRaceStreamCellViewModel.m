//
//  SRHRaceStreamViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-01.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceStreamCellViewModel.h"
#import "SRHStream.h"
#import "SRHGame.h"
#import "SRHStreamer.h"
#import "UIColor+SRHColors.h"

@interface SRHRaceStreamCellViewModel ()

@property(nonatomic, strong) NSAttributedString *cellStreamTitle;
@property(nonatomic, strong) NSURL *cellStreamPreviewImageURL;
@property(nonatomic, strong) NSURL *cellStreamerImageURL;

@end

@implementation SRHRaceStreamCellViewModel

-(instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (self) {
        _stream = stream;
        
//        RAC(self, cellStreamTitle) = RACObserve(self, self.stream.title);
        RAC(self, cellStreamTitle) = [RACSignal combineLatest:@[ RACObserve(self, self.stream.streamer.name),
                                                                 RACObserve(self, self.stream.game)]
                                                       reduce:^id(NSString *streamerName, SRHGame *game){
                                                           NSMutableAttributedString *cellTitle = [[NSMutableAttributedString alloc] init];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamerName attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:14.0],
                                                                                                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing\n" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:13.0],
                                                                                                                                                                    NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
                                                           [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Bold" size:13.0],
                                                                                                                                                                                                                    NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
                                                           
                                                           return [cellTitle copy];
                                                        }];
        RAC(self, cellStreamPreviewImageURL) = RACObserve(self, self.stream.currentThumbnail);
        RAC(self, cellStreamerImageURL) = RACObserve(self, self.stream.streamer.avatarURL);
    }
    
    return self;

}

@end
