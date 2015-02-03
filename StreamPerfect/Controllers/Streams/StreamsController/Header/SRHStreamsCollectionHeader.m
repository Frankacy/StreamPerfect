//
//  SRHStreamsCollectionHeader.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsCollectionHeader.h"
#import "SRHStreamsSectionViewModel.h"
#import "UIColor+SRHColors.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString* const SRHStreamCollectionViewHeader = @"SRHStreamsPopularHeader";

@interface SRHStreamsCollectionHeader ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *headerImageView;

@end

@implementation SRHStreamsCollectionHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupHeader];
    
    return self;
}

- (void)setupHeader {
    self.backgroundColor = [UIColor srhLightGrayColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor srhDarkBlueColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.backgroundColor = [UIColor srhLightGrayColor];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:24.0];
    [self addSubview:self.titleLabel];
    
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popular_section_arrows"]];
    self.headerImageView.backgroundColor = [UIColor srhLightGrayColor];
    [self addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.superview.mas_left);
        make.top.equalTo(self.headerImageView.superview.mas_top);
        make.bottom.equalTo(self.headerImageView.superview.mas_bottom);
        make.width.equalTo(self.headerImageView.mas_height).multipliedBy(18.0/20.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.superview.mas_centerY);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(8);
        make.right.equalTo(self.titleLabel.superview.mas_right);
    }];
}

-(void)setViewModel:(SRHStreamsSectionViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self updateContent];
}

-(void)updateContent {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, headerTitle) takeUntil:self.rac_prepareForReuseSignal];
}

-(NSString *)reuseIdentifier {
    return SRHStreamCollectionViewHeader;
}

@end