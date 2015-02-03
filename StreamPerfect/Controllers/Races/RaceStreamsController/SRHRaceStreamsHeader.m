//
//  SRHRaceStreamsHeader.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-15.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceStreamsHeader.h"
#import "UIColor+SRHColors.h"
#import "SRHRaceStreamsViewModel.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString* const SRHRaceStreamsCollectionViewHeader = @"SRHRaceStreamsHeader";

@interface SRHRaceStreamsHeader ()

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *gameLabel;
@property(nonatomic, strong) UILabel *goalLabel;
@property(nonatomic, strong) UILabel *entrantsNumberLabel;
@property(nonatomic, strong) UILabel *entrantsLabel;
@property(nonatomic, strong) UIView *borderSeparator;

@end

@implementation SRHRaceStreamsHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupHeader];
    [self setupContstraints];
    
    return self;
}

- (NSString *)reuseIdentifier {
    return SRHRaceStreamsCollectionViewHeader;
}

- (void)setViewModel:(SRHRaceStreamsViewModel *)viewModel {
    _viewModel = viewModel;
    
    RAC(self.gameLabel, text) = [RACObserve(self.viewModel, gameLabelText) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.goalLabel, text) = [RACObserve(self.viewModel, goalLabelText) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.entrantsNumberLabel, text) = [RACObserve(self.viewModel, entrantsNumberLabelText) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.entrantsLabel, text) = [RACObserve(self.viewModel, entrantsLabelText) takeUntil:self.rac_prepareForReuseSignal];
    
    [self setNeedsLayout];
}

- (void)setupHeader {
    self.backgroundColor = [UIColor whiteColor];
    _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    [self addSubview:_iconImageView];
    
    _gameLabel = [[UILabel alloc] init];
    _gameLabel.textColor = [UIColor srhDarkBlueColor];
    _gameLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
    _gameLabel.text = @"Mega Man X";
    [self addSubview:_gameLabel];
    
    _goalLabel = [[UILabel alloc] init];
    _goalLabel.textColor = [UIColor srhBlueGrayColor];
    _goalLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:16.0];
    _goalLabel.text = @"Any % no hearts";
    [self addSubview:_goalLabel];
    
    _entrantsNumberLabel = [[UILabel alloc] init];
    _entrantsNumberLabel.textColor = [UIColor srhPurpleColor];
    _entrantsNumberLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:17.0];
    _entrantsNumberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_entrantsNumberLabel];
    
    _entrantsLabel = [[UILabel alloc] init];
    _entrantsLabel.textColor = [UIColor srhBlueGrayColor];
    _entrantsLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:13.0];
    [self addSubview:_entrantsLabel];
    
    _borderSeparator = [[UIView alloc] init];
    _borderSeparator.backgroundColor = [UIColor srhTableSeparatorColor];
    [self addSubview:_borderSeparator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(10, 30, 10, 30);
    
    [self.goalLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.gameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.entrantsLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.entrantsNumberLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.iconImageView.superview).with.insets(contentInsets);
        make.height.equalTo(@(self.iconImageView.intrinsicContentSize.height));
        make.width.equalTo(@(self.iconImageView.intrinsicContentSize.width));
    }];
    
    [self.entrantsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.entrantsNumberLabel.superview).with.insets(contentInsets);
        make.right.equalTo(self.entrantsLabel.mas_right).priorityHigh();
    }];
    
    [self.entrantsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.entrantsNumberLabel.mas_bottom).with.offset(2);
        make.right.equalTo(self.entrantsLabel.superview).with.insets(contentInsets).priorityHigh();
    }];
    
    [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(@[self.entrantsNumberLabel.mas_left,
                                       self.entrantsLabel.mas_left]).with.offset(-10).priorityMedium();
    }];
    
    [self.goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(@[self.entrantsNumberLabel.mas_left,
                                       self.entrantsLabel.mas_left]).with.offset(-10).priorityMedium();
    }];
    
    [self.borderSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.borderSeparator.superview);
        make.height.equalTo(@1);
    }];
}

- (void)setupContstraints {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(10, 30, 10, 30);
    
    [self.goalLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.gameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.entrantsLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.entrantsNumberLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.iconImageView.superview).with.insets(contentInsets);
        make.height.equalTo(@(self.iconImageView.intrinsicContentSize.height));
        make.width.equalTo(@(self.iconImageView.intrinsicContentSize.width));
    }];
    
    [self.entrantsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self.entrantsNumberLabel.superview).with.insets(contentInsets).priority(1000);
    }];
    
    [self.entrantsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.entrantsNumberLabel.mas_bottom).with.offset(2);
        make.right.equalTo(self.entrantsLabel.superview).with.insets(contentInsets).priority(1000);
    }];
    
    [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(@[self.entrantsNumberLabel.mas_left,
                                       self.entrantsLabel.mas_left]).with.offset(-10).priorityMedium();
    }];
    
    [self.goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(@[self.entrantsNumberLabel.mas_left,
                                       self.entrantsLabel.mas_left]).with.offset(-10).priorityMedium();
    }];
    
    [self.borderSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.borderSeparator.superview);
        make.height.equalTo(@1);
    }];
}

@end
