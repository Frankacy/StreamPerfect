//
//  SRHRaceStreamsViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@class SRHStream;
@class SRHRace;
@class SRHRaceStreamCellViewModel;

@interface SRHRaceStreamsViewModel : RVMViewModel

@property(nonatomic, strong, readonly) NSArray *raceStreams;
@property(nonatomic, strong, readonly) RACSignal *updatedContentSignal;
@property(nonatomic, strong) NSString *gameLabelText;
@property(nonatomic, strong) NSString *goalLabelText;
@property(nonatomic, strong) NSString *entrantsNumberLabelText;
@property(nonatomic, strong) NSString *entrantsLabelText;

-(instancetype)initWithRace:(SRHRace *)race; 

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(SRHStream *)itemAtIndexPath:(NSIndexPath *)indexPath;
-(SRHRaceStreamCellViewModel *)viewModelForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
