//
//  SRHStreamsDetailsHeader.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-30.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamDetailsHeader.h"
#import "UIColor+SRHColors.h"
#import "SRHAccountManager.h"

#import "SRHStream.h"
#import "SRHStreamer.h"
#import "SRHGame.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface SRHStreamDetailsHeader ()

@property (nonatomic, weak) SRHStream *stream;

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *mainTitleLabel;
@property (nonatomic, weak) UILabel *streamTitleLabel;
@property (nonatomic, weak) UILabel *followerNumberLabel;
@property (nonatomic, weak) UILabel *followerTitleLabel;
@property (nonatomic, weak) UILabel *viewersNumberLabel;
@property (nonatomic, weak) UILabel *viewersTitleLabel;

@property (nonatomic, weak) UIImageView *barImageView;
@property (nonatomic, weak) UIImageView *streamTitleIconImageView;

@end

@implementation SRHStreamDetailsHeader

- (instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stream = stream;
    [self setupView];
    
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    [avatarImageView sd_setImageWithURL:self.stream.streamer.avatarURL];
    [self addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.textColor = [UIColor srhDarkBlueColor];
    mainTitleLabel.attributedText = [self headerTitleWithStreamer:self.stream.streamer game:self.stream.game];
    mainTitleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:22.0];
    [self addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *streamTitleLabel = streamTitleLabel = [[UILabel alloc] init];
    streamTitleLabel.textColor = [UIColor srhBlueGrayColor];
    streamTitleLabel.text = self.stream.title;
    streamTitleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:18.0];
    [self addSubview:streamTitleLabel];
    self.streamTitleLabel = streamTitleLabel;
    
    UIImageView *streamTitleIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popular_section_arrows"]];
    [self addSubview:streamTitleIconImageView];
    self.streamTitleIconImageView = streamTitleIconImageView;
    
    UILabel *followerNumberLabel = [[UILabel alloc] init];
    followerNumberLabel.textColor = [UIColor srhPurpleColor];
    followerNumberLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
    followerNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stream.streamer.followerCount];
    [self addSubview:followerNumberLabel];
    self.followerNumberLabel = followerNumberLabel;
    
    UILabel *followerTitleLabel = [[UILabel alloc] init];
    followerTitleLabel.textColor = [UIColor srhBlueGrayColor];
    followerTitleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:14.0];
    followerTitleLabel.text = self.stream.streamer.followerCount == 1 ? @"follower" : @"followers";
    [self addSubview:followerTitleLabel];
    self.followerTitleLabel = followerTitleLabel;
    
    UILabel *viewersNumberLabel = [[UILabel alloc] init];
    viewersNumberLabel.textColor = [UIColor srhPurpleColor];
    viewersNumberLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
    viewersNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stream.currentViewerCount + 1];
    [self addSubview:viewersNumberLabel];
    self.viewersNumberLabel = viewersNumberLabel;
    
    UILabel *viewersTitleLabel = [[UILabel alloc] init];
    viewersTitleLabel.textColor = [UIColor srhBlueGrayColor];
    viewersTitleLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:14.0];
    viewersTitleLabel.text = self.stream.currentViewerCount == 0 ? @"viewer" : @"viewers";
    [self addSubview:viewersTitleLabel];
    self.viewersTitleLabel = viewersTitleLabel;
    
    UIImageView *barImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_streams_section_bar"]];
    [self addSubview:barImageView];
    self.barImageView = barImageView;
    
    [self.mainTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.streamTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.followerNumberLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.followerTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewersNumberLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewersTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self);
        make.bottom.equalTo(self.barImageView.mas_top);
        make.width.equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLabel.superview.mas_top).with.offset(29);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(20.0);
        make.right.lessThanOrEqualTo(@[self.followerNumberLabel,
                                       self.followerTitleLabel,
                                       self.viewersNumberLabel,
                                       self.viewersTitleLabel]).with.offset(-10);
    }];
    
    [self.streamTitleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLabel.mas_bottom).with.offset(6.0);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(20.0);
        make.height.equalTo(@14);
        make.width.equalTo(@15);
    }];
    
    [self.streamTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLabel.mas_bottom).with.offset(5.0);
        make.left.equalTo(self.streamTitleIconImageView.mas_right).with.offset(5.0);
        make.right.lessThanOrEqualTo(@[self.followerNumberLabel,
                                       self.followerTitleLabel,
                                       self.viewersNumberLabel,
                                       self.viewersTitleLabel]).with.offset(-10);
    }];
    
    UIEdgeInsets rightEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 30);
    
    [self.followerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(self.followerNumberLabel.superview).with.insets(rightEdgeInsets);
    }];
    
    [self.followerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followerNumberLabel.mas_bottom);
        make.right.equalTo(self.followerTitleLabel.superview).with.insets(rightEdgeInsets);
    }];
    
    [self.viewersNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followerTitleLabel.mas_bottom).with.offset(5.0);
        make.right.equalTo(self.viewersNumberLabel.superview).with.insets(rightEdgeInsets);
    }];
    
    [self.viewersTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewersNumberLabel.mas_bottom);
        make.right.equalTo(self.viewersTitleLabel.superview).with.insets(rightEdgeInsets);
    }];
    
    [self.barImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.barImageView.superview);
        make.height.equalTo(@6);
    }];
}

- (NSAttributedString *)headerTitleWithStreamer:(SRHStreamer *)streamer game:(SRHGame *)game {
   NSMutableAttributedString *cellTitle = [[NSMutableAttributedString alloc] init];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamer.name
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:24.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing "
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:20.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something"
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Bold" size:22.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
   
   return [cellTitle copy];
}

@end
