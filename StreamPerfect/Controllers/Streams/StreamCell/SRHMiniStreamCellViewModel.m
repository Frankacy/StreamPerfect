//
//  SRHMiniStreamCellViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-09-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHMiniStreamCellViewModel.h"
#import "SRHStream.h"
#import "SRHGame.h"
#import "SRHStreamer.h"
#import "UIColor+SRHColors.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SRHMiniStreamCellViewModel ()

@property(nonatomic, strong) NSAttributedString *cellStreamTitle;
@property(nonatomic, strong) NSURL *cellStreamPreviewImageURL;
@property(nonatomic, strong) NSURL *cellStreamerImageURL;

@end

@implementation SRHMiniStreamCellViewModel

-(instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (self) {
        _stream = stream;
        
        _cellStreamTitle = [self attributedCellTitleWithStreamer:stream.streamer game:stream.game];
        _cellStreamPreviewImageURL = self.stream.currentThumbnail;
        _cellStreamerImageURL = self.stream.streamer.avatarURL;
    }
    
    return self;
}

- (NSAttributedString *)attributedCellTitleWithStreamer:(SRHStreamer *)streamer game:(SRHGame *)game {
   NSMutableAttributedString *cellTitle = [[NSMutableAttributedString alloc] init];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamer.name attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:15.0],
                                                                                                           NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing\n" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:13.0],
                                                                                                            NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something" attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat" size:13.0],
                                                                                                                                                            NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
   
   return [cellTitle copy];
}

@end
