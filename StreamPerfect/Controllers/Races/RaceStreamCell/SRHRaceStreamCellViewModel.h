//
//  SRHRaceStreamViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-01.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRHStream;

@interface SRHRaceStreamCellViewModel : NSObject

@property(nonatomic, strong) SRHStream *stream;

@property(nonatomic, strong, readonly) NSAttributedString *cellStreamTitle;
@property(nonatomic, strong, readonly) NSURL *cellStreamPreviewImageURL;
@property(nonatomic, strong, readonly) NSURL *cellStreamerImageURL;

-(instancetype)initWithStream:(SRHStream *)stream;
    
@end
