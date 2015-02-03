//
//  SRHRacesSectionViewModel.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRacesSectionViewModel.h"

@implementation SRHRacesSectionViewModel

-(instancetype)initWithRaces:(NSArray *)races title:(NSString *)title iconName:(NSString *)iconName {
    self = [super init];
    if (self) {
        _races = [self orderedRaces:races];
        _headerTitle = title;
        _iconName = iconName;
    }
    
    return self;
}

- (NSArray *)orderedRaces:(NSArray *)races {
    return [races sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"elapsedTime" ascending:YES] ]];
}

@end
