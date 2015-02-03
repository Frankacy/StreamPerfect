//
//  SRHStreamCellViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamCellViewModel.h"
#import "SRHStream.h"
#import "SRHGame.h"
#import "SRHStreamer.h"
#import "UIColor+SRHColors.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SRHStreamCellViewModel ()

@property(nonatomic, strong) NSAttributedString *cellStreamTitle;
@property(nonatomic, strong) NSURL *cellStreamPreviewImageURL;
@property(nonatomic, strong) NSURL *cellStreamerImageURL;

@end

@implementation SRHStreamCellViewModel

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
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamer.name
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:17.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing\n"
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:15.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something"
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat" size:15.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
   
   return [cellTitle copy];
}

@end
