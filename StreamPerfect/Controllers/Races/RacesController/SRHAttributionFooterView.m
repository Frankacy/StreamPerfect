//
//  SRHAttributionFooterView.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-09-06.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHAttributionFooterView.h"
#import "UIColor+SRHColors.h"
#import <Masonry/Masonry.h>

@interface SRHAttributionFooterView ()

@property(nonatomic, strong) NSString *title;
@property(nonatomic, weak) UILabel *attributionLabel;
@property(nonatomic, weak) UIView *seperatorView;

@end

@implementation SRHAttributionFooterView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 75)];
    if (!self) {
        return nil;
    }
    
    _title = title;
    [self setupView];
    [self setupContstraints];
    
    return self;
}

- (void)setupView {
    UILabel *label = [[UILabel alloc] init];
    label.text = self.title;
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor srhGrayTextColor];
    [self addSubview:label];
    self.attributionLabel = label;
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    seperator.backgroundColor = [UIColor srhTableSeparatorColor];
    [self addSubview:seperator];
    self.seperatorView = seperator;
}

- (void)setupContstraints {
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.top.left.right.equalTo(self.seperatorView.superview);
    }];
    
    [self.attributionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.attributionLabel.superview).with.insets(insets);
    }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(150, 100);
}
@end
