//
//  SRHStreamsViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

extern NSInteger const SRHFeaturedCellCount;

@class SRHStreamCellViewModel;
@class SRHStream;

@interface SRHStreamsViewModel : RVMViewModel

@property(nonatomic, strong, readonly) NSArray *sectionViewModels;
@property(nonatomic, strong, readonly) RACSignal *updatedContentSignal;
@property(nonatomic, strong, readonly) RACCommand *updateContentCommand;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(SRHStream *)itemAtIndexPath:(NSIndexPath *)indexPath;
-(RVMViewModel *)viewModelForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
