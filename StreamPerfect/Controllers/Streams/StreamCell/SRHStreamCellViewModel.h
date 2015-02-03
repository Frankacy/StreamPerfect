//
//  SRHStreamCellViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@class SRHStream;

@interface SRHStreamCellViewModel : RVMViewModel

@property(nonatomic, strong) SRHStream *stream;

@property(nonatomic, strong, readonly) NSAttributedString *cellStreamTitle;
@property(nonatomic, strong, readonly) NSURL *cellStreamPreviewImageURL;
@property(nonatomic, strong, readonly) NSURL *cellStreamerImageURL;

-(instancetype)initWithStream:(SRHStream *)stream;

@end
