//
//  SRHMiniStreamCell.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-28.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHMiniStreamCell.h"
#import "SRHStreamCellViewModel.h"
#import "UIColor+SRHColors.h"
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
        
        RAC(self, self.cellTitleLabel.attributedText) = RACObserve(self, self.viewModel.cellStreamTitle);
        
        [RACObserve(self, self.viewModel.cellStreamPreviewImageURL) subscribeNext:^(NSURL *url) {
            [self.previewImageView sd_setImageWithURL:url];
        }];
    }
    return self;
}

- (void)setViewModel:(SRHStreamCellViewModel *)viewModel {
    _viewModel = viewModel;
    
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

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self reset];
}

- (void)reset {
}

@end
