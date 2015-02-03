//
//  SRHRaceStreamCell.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-01.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRaceStreamCell.h"
#import "SRHRaceStreamCellViewModel.h"
#import "UIColor+SRHColors.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface SRHRaceStreamCell ()

@property(nonatomic, strong) UIImageView *previewImageView;
@property(nonatomic, strong) UILabel *cellTitleLabel;

@end

@implementation SRHRaceStreamCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
        
        RAC(self, self.cellTitleLabel.attributedText) = RACObserve(self, self.viewModel.cellStreamTitle);
        
        @weakify(self)
        [RACObserve(self, self.viewModel.cellStreamPreviewImageURL) subscribeNext:^(NSURL *url) {
            @strongify(self)
            [self.previewImageView sd_setImageWithURL:url];
        }];
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
    self.cellTitleLabel.textColor = [UIColor srhPurpleColor];
    self.cellTitleLabel.numberOfLines = 2;
    
    self.layer.shadowColor = [[UIColor srhTurquoiseColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.clipsToBounds = NO;
    
    [self.contentView addSubview:self.previewImageView];
    [self.contentView addSubview:self.cellTitleLabel];
    
    //Preview image constraints
    
    UIEdgeInsets previewImagePadding = UIEdgeInsetsMake(7, 7, 0, 7);
    
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(previewImagePadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(previewImagePadding.left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-previewImagePadding.right);
        make.width.equalTo(self.previewImageView.mas_height).multipliedBy(26.0/15.0);
    }];
    
    //Game label constraints
    
    UIEdgeInsets cellTitlePadding = UIEdgeInsetsMake(5, 7, 0, 7);
    
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.previewImageView.mas_bottom).with.offset(cellTitlePadding.top);
        make.left.equalTo(self.contentView.mas_left).with.offset(cellTitlePadding.left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-cellTitlePadding.right);
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
    //Reset stuff for reuse
}


@end
