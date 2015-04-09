//
//  SRHMiniStreamCell.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-28.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHMiniStreamCell.h"
#import "UIColor+SRHColors.h"
#import "SRHStream.h"
#import "SRHStreamer.h"
#import "SRHGame.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface SRHMiniStreamCell ()

@property(nonatomic, strong) UIImageView *previewImageView;
@property(nonatomic, strong) UILabel *cellTitleLabel;

@end

@implementation SRHMiniStreamCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    //Create cell subviews
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 8;
    
    self.previewImageView = [[UIImageView alloc] init];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImageView.backgroundColor = [UIColor blackColor];
    self.previewImageView.layer.cornerRadius = 4;
    self.previewImageView.clipsToBounds = YES;
    
    self.cellTitleLabel = [[UILabel alloc] init];
    self.cellTitleLabel.numberOfLines = 2;
    self.cellTitleLabel.textColor = [UIColor srhPurpleColor];
    
    [self.contentView addSubview:self.previewImageView];
    [self.contentView addSubview:self.cellTitleLabel];
    
    //Preview image constraints
    
    UIEdgeInsets previewImagePadding = UIEdgeInsetsMake(7, 7, 0, 7);
    
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(previewImagePadding.top); //with is an optional semantic filler
        make.left.equalTo(self.contentView.mas_left).with.offset(previewImagePadding.left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-previewImagePadding.right);
        make.width.equalTo(self.previewImageView.mas_height).multipliedBy(26.0/15.0);
    }];
    
    //Game label constraints
    
    UIEdgeInsets cellTitlePadding = UIEdgeInsetsMake(4, 7, 0, 7);
    
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.previewImageView.mas_bottom).with.offset(cellTitlePadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(cellTitlePadding.left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-cellTitlePadding.right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.contentView.layer setMasksToBounds:NO];
    [self.contentView.layer setShadowColor:[[UIColor srhTurquoiseColor] CGColor]];
    [self.contentView.layer setShadowOffset:CGSizeMake(1.0f,4.0f)];
    [self.contentView.layer setShadowOpacity:1.0];
    [self.contentView.layer setShadowRadius:0.0];
}

- (void)setStream:(SRHStream *)stream {
    if (_stream != stream) {
        _stream = stream;
        
        [self updateContent];
    }
}

- (void)updateContent {
    self.cellTitleLabel.attributedText = [self attributedCellTitleWithStreamer:self.stream.streamer
                                                                          game:self.stream.game];
    [self.previewImageView sd_setImageWithURL:self.stream.currentThumbnail];
}

- (NSAttributedString *)attributedCellTitleWithStreamer:(SRHStreamer *)streamer game:(SRHGame *)game {
   NSMutableAttributedString *cellTitle = [[NSMutableAttributedString alloc] init];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:streamer.name
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Bold" size:17.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" playing\n"
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Bariol-Regular" size:15.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhBlueGrayColor]}]];
   [cellTitle appendAttributedString:[[NSAttributedString alloc] initWithString:game.name ? [[game shortName] uppercaseString] : @"Something"
                                                                     attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Montserrat" size:15.0],
                                                                                   NSForegroundColorAttributeName : [UIColor srhDarkBlueColor]}]];
   
   return [cellTitle copy];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self reset];
}

- (void)reset {
}

@end
