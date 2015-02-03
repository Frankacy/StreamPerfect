//
//  SRHRaceCellViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-30.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@class SRHRace;

@interface SRHRaceCellViewModel : RVMViewModel

@property(nonatomic, strong) SRHRace *race;

@property(nonatomic, strong, readonly) NSURL *gameImageURL;
@property(nonatomic, strong, readonly) NSString *goalText;
@property(nonatomic, strong, readonly) NSString *gameTitle;

- (instancetype)initWithRace:(SRHRace *)race;

@end
