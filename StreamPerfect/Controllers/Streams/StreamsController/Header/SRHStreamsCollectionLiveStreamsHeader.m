//
//  SRHStreamsCollectionHeader.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-04.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsCollectionLiveStreamsHeader.h"
#import "SRHStreamsSectionViewModel.h"
#import "UIColor+SRHColors.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString* const SRHStreamCollectionViewLiveStreamsHeader = @"SRHStreamsLiveStreamsHeader";

@interface SRHStreamCollectionLiveStreamsHeader ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UIImageView *barImageView;

@end

@implementation SRHStreamCollectionLiveStreamsHeader

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
    
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_streams_section_camera"]];
    self.headerImageView.backgroundColor = [UIColor srhLightGrayColor];
    [self addSubview:self.headerImageView];
    
    self.barImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_streams_section_bar"]];
    self.barImageView.backgroundColor = [UIColor srhLightGrayColor];
    [self addSubview:self.barImageView];
    
    [self.barImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barImageView.superview.mas_top);
        make.left.equalTo(self.barImageView.superview.mas_left);
        make.right.equalTo(self.barImageView.superview.mas_right);
        make.height.equalTo(@6);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.superview.mas_left).offset(50);
        make.top.equalTo(self.barImageView.mas_bottom).offset(16);
        make.bottom.equalTo(self.headerImageView.superview.mas_bottom);
        //TODO
        make.width.equalTo(self.headerImageView.mas_height).multipliedBy(29.0/31.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(8);
        make.right.equalTo(self.titleLabel.superview.mas_right);
    }];
    
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, headerTitle);
}

- (void)setViewModel:(SRHStreamsSectionViewModel *)viewModel {
    _viewModel = viewModel;
    
    [self updateContent];
}

- (void)updateContent {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, headerTitle) takeUntil:self.rac_prepareForReuseSignal];
}

- (NSString *)reuseIdentifier {
    return SRHStreamCollectionViewLiveStreamsHeader;
}

@end