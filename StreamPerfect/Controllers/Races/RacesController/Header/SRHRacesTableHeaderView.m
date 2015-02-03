//
//  SRHRacesTableHeaderView.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-17.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRacesTableHeaderView.h"
#import "UIColor+SRHColors.h"

#import <Masonry/Masonry.h>

@interface SRHRacesTableHeaderView ()

@property(nonatomic, copy) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *iconImageView;

@end

@implementation SRHRacesTableHeaderView

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor srhMediumGrayColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor srhBlueGrayColor];
    _titleLabel.font = [UIFont fontWithName:@"Montserrat" size:12.0];
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
    
    _iconImageView = [[UIImageView alloc] initWithImage:icon];
    [self addSubview:_iconImageView];
    
    [self setupConstraints];
    
    return self;
}

- (void)setupConstraints {
    UIEdgeInsets contentInset = UIEdgeInsetsMake(2, 20, 2, 10);
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.superview).with.insets(contentInset);
        make.centerY.equalTo(self.iconImageView.superview.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
        make.top.and.bottom.equalTo(self.titleLabel.superview).with.insets(contentInset);
    }];
}


@end
