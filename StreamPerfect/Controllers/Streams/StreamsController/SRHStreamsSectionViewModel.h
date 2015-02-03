//
//  SRHStreamsSectionViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@interface SRHStreamsSectionViewModel : RVMViewModel

@property(nonatomic, copy) NSString *headerTitle;
@property(nonatomic, strong) NSArray *streams;

-(instancetype)initWithStreams:(NSArray *)streams andTitle:(NSString *)title;

@end
