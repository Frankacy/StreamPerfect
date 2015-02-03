//
//  SRHRacesViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@class SRHRace;
@class SRHRaceCellViewModel;

@interface SRHRacesViewModel : RVMViewModel

@property(nonatomic, strong, readonly) NSArray *sectionViewModels;
@property(nonatomic, strong, readonly) RACSignal *updatedContentSignal;
@property(nonatomic, strong, readonly) RACCommand *updateContentCommand;
@property(nonatomic, strong) SRHRace *selectedRace;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (SRHRace *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (SRHRaceCellViewModel *)viewModelForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (UIImage *)iconForHeaderInSection:(NSInteger)section;

@end
