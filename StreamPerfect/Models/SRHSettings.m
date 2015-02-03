//
//  SRHSettings.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHSettings.h"

@implementation SRHSettings

-(id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _showNoSRLStreams = NO;
    _showCompletedRaces = YES;
    _sortType = SRHStreamSortTypeFollowers;
    
    return self;
}

@end
