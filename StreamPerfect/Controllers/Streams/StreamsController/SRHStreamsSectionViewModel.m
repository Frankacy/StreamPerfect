//
//  SRHStreamsSectionViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsSectionViewModel.h"

@implementation SRHStreamsSectionViewModel

-(instancetype)initWithStreams:(NSArray *)streams andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _streams = streams;
        _headerTitle = title;
    }
    
    return self;
}

@end
