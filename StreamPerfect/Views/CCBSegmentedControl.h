//
//  CCBSegmentedControl.h
//  HMSegmentedControlExample
//
//  Created by Francois Courville on 2014-08-28.
//  Copyright (c) 2014 Hesham Abd-Elmegid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, CCBSegmentedControlType) {
    CCBSegmentedControlTypeText,
    CCBSegmentedControlTypeImages,
    CCBSegmentedControlTypeTextImages,
};

typedef NS_ENUM(NSInteger, CCBSegmentedControlSegmentWidthStyle) {
    CCBSegmentedControlSegmentWidthStyleFixed,
    CCBSegmentedControlSegmentWidthStyleDynamic
};

@interface CCBSegmentedControl : UIControl

//Segment content properties
@property (nonatomic, strong, readonly) NSArray *sectionTitles;
@property (nonatomic, strong, readonly) NSArray *sectionImages;
@property (nonatomic, strong, readonly) NSArray *sectionSelectedImages;
@property (nonatomic, assign, readonly) CCBSegmentedControlType type;
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

//Customization properties
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, assign) CGFloat titleImageSpacing;
@property (nonatomic, assign) CCBSegmentedControlSegmentWidthStyle segmentWidthStyle;
@property (nonatomic, assign) BOOL shouldAnimateUserSelection;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) CGFloat selectionIndicatorHeight;
@property (nonatomic, assign) CGFloat selectionIndicatorWidth;

- (instancetype)initWithSectionTitles:(NSArray *)sectiontitles;
- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages;
- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles;

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;

- (void)addTitleOffset:(CGPoint)offest forSegmentAtIndex:(NSInteger)index;
- (void)addImageOffset:(CGPoint)offset forSegmentAtIndex:(NSInteger)index;

@end
