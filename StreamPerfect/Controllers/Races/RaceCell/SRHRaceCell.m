//
//  SRHRaceCell.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceCell.h"
#import "UIColor+SRHColors.h"
#import "SRHRace.h"
#import "SRHGame.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface SRHRaceCell ()

@property(nonatomic, strong) UIImageView *gameImageView;
@property(nonatomic, strong) UILabel *goalLabel;
@property(nonatomic, strong) UILabel *gameLabel;
@property(nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation SRHRaceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
        
    }
    return self;
}

- (void)setupCell {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.separatorInset = UIEdgeInsetsZero;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    self.backgroundColor = [UIColor srhLightGrayColor];
    self.contentView.backgroundColor = [UIColor srhLightGrayColor];
    self.selectedBackgroundView = [self createSelectedBackgroundView];
    
    self.gameImageView = [[UIImageView alloc] init];
    self.gameImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.gameImageView.clipsToBounds = YES;
    self.gameImageView.layer.cornerRadius = 4;
    self.gameImageView.backgroundColor = [UIColor srhMediumGrayColor];
    [self.contentView addSubview:self.gameImageView];
    
    self.gameLabel = [[UILabel alloc] init];
    self.gameLabel.textColor = [UIColor srhDarkBlueColor];
    self.gameLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16.0];
    [self.contentView addSubview:self.gameLabel];
    
    self.goalLabel = [[UILabel alloc] init];
    self.goalLabel.textColor = [UIColor srhBlueGrayColor];
    self.goalLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:15.0];
    [self.contentView addSubview:self.goalLabel];
    
    self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    [self.contentView addSubview:self.accessoryImageView];
   
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.bottom.equalTo(self.contentView).with.insets(contentInsets);
        make.width.equalTo(self.gameImageView.mas_height);
    }];
    
    [self.gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameImageView.mas_right).with.offset(10);
        make.right.equalTo(self.accessoryImageView.mas_left).with.offset(-10);
        make.bottom.equalTo(self.gameLabel.superview.mas_centerY);
    }];
    
    [self.goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameLabel.mas_bottom).with.offset(3.0);
        make.left.equalTo(self.gameImageView.mas_right).with.offset(10);
        make.right.equalTo(self.accessoryImageView.mas_left).with.offset(-10);
    }];
    
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accessoryImageView.superview.mas_centerY);
        make.right.equalTo(self.accessoryImageView.superview.mas_right).with.offset(-15);
        make.width.equalTo(@(self.accessoryImageView.intrinsicContentSize.width));
    }];
}

- (UIView *)createSelectedBackgroundView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor srhTurquoiseColor];
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor srhPurpleColor];
    [backgroundView addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(shadowView.superview);
        make.height.equalTo(@3);
    }];
    
    return backgroundView;
}

//This fixes the fact that UIViews background colors are set to clear when cell is selected (Thank you Apple!)
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *backgroundColor = self.gameImageView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.gameImageView.backgroundColor = backgroundColor;
}

- (void)setRace:(SRHRace *)race {
    if (_race != race) {
        _race = race;
        
        [self updateContent];
    }
}

- (void)updateContent {
    self.goalLabel.text = self.race.goal;
    self.gameLabel.text = self.race.game.name;
    
    [self.race.game getArtworkURLWithCompletion:^(NSURL *artworkURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gameImageView sd_setImageWithURL:artworkURL];
        });
    }];
}

@end