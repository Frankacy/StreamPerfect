//
//  SRHRacesSectionViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@interface SRHRacesSectionViewModel : RVMViewModel

@property(nonatomic, copy) NSString *headerTitle;
@property(nonatomic, copy) NSString *iconName;
@property(nonatomic, strong) NSArray *races;

-(instancetype)initWithRaces:(NSArray *)races title:(NSString *)title iconName:(NSString *)iconName;

@end
