//
//  CCBSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Francois Courville on 2014-08-28.
//  Copyright (c) 2014 Hesham Abd-Elmegid. All rights reserved.
//

#import "CCBSegmentedControl.h"

@interface CCBSegmentedControl ()

@property (nonatomic, strong, readwrite) NSArray *sectionTitles;
@property (nonatomic, strong, readwrite) NSArray *sectionImages;
@property (nonatomic, strong, readwrite) NSArray *sectionSelectedImages;
@property (nonatomic, assign, readwrite) CCBSegmentedControlType type;

@property (nonatomic, strong) CALayer *selectionIndicatorLayer;
@property (nonatomic, strong) NSArray *segmentWidths;
@property (nonatomic, strong) NSMutableArray *titleOffsets;
@property (nonatomic, strong) NSMutableArray *imageOffsets;
@property (nonatomic, assign) CGPoint selectionIndicatorOffset;

@property (nonatomic, assign) CGFloat minimumLateralPadding;

@end

@implementation CCBSegmentedControl

#pragma mark -
#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    self.sectionTitles = sectiontitles;
    self.type = CCBSegmentedControlTypeText;
    
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages {
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    self.sectionImages = sectionImages;
    self.sectionSelectedImages = sectionSelectedImages;
    self.type = CCBSegmentedControlTypeImages;
    
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    if (!self) {
        return nil;
    }
    
    if (sectionImages.count != sectiontitles.count) {
		[NSException raise:NSRangeException format:@"***%s: CCBSegmentedControl must be initialized with the same number of images and titles. sectionImages count (%ld) doesn't match sectionTitles count (%ld)", sel_getName(_cmd), (unsigned long)sectionImages.count, (unsigned long)sectiontitles.count];
    }
		
    [self commonInit];
    self.sectionImages = sectionImages;
    self.sectionSelectedImages = sectionSelectedImages;
    self.sectionTitles = sectiontitles;
    self.type = CCBSegmentedControlTypeTextImages;
    
    return self;
}

- (void)commonInit {
    self.opaque = NO;
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor darkGrayColor];
    self.selectedTextColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = [UIColor blueColor];
    self.titleImageSpacing = 5.0f;
    
    self.selectedSegmentIndex = 0;
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorWidth = 5.0f;
    self.segmentWidthStyle = CCBSegmentedControlSegmentWidthStyleFixed;
    self.type = CCBSegmentedControlTypeText;
    
    self.shouldAnimateUserSelection = YES;
    self.selectionIndicatorLayer = [CALayer layer];
    self.minimumLateralPadding = 5.0;
    self.selectionIndicatorOffset = CGPointZero;
    
    self.contentMode = UIViewContentModeRedraw; //Check this
}

#pragma mark -
#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentWidths];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = [[self.segmentWidths valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    return CGSizeMake(width, CGRectGetHeight(self.frame));
}

#pragma mark -
#pragma mark - Custom setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateSegmentWidths];
}

- (void)setSectionTitles:(NSArray *)sectionTitles {
    _sectionTitles = sectionTitles;
    
    [self setNeedsLayout];
}

- (void)setSectionImages:(NSArray *)sectionImages {
    _sectionImages = sectionImages;
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.selectionIndicatorLayer.backgroundColor = [self.selectionIndicatorColor CGColor];
    self.layer.sublayers = nil;
    
    __weak CCBSegmentedControl *weakSelf = self;
    
    if (self.type == CCBSegmentedControlTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL *stop) {
            CGPoint offset = weakSelf.titleOffsets[idx] ? [weakSelf.titleOffsets[idx] CGPointValue] : CGPointZero;
            [weakSelf addLayerForTitle:title titleOffset:offset image:nil imageOffset:CGPointZero atIndex:idx];
        }];
    } else if (self.type == CCBSegmentedControlTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id image, NSUInteger idx, BOOL *stop) {
            CGPoint offset = weakSelf.imageOffsets[idx] ? [weakSelf.imageOffsets[idx] CGPointValue] : CGPointZero;
            [weakSelf addLayerForTitle:nil titleOffset:CGPointZero image:image imageOffset:offset atIndex:idx];
        }];
    } else if (self.type == CCBSegmentedControlTypeTextImages) {
        NSInteger segmentCount = [self segmentCount];
        for (NSInteger i = 0; i < segmentCount; i++) {
            CGPoint titleOffset = self.titleOffsets[i] ? [self.titleOffsets[i] CGPointValue] : CGPointZero;
            CGPoint imageOffset = self.imageOffsets[i] ? [self.imageOffsets[i] CGPointValue] : CGPointZero;
            [self addLayerForTitle:self.sectionTitles[i] titleOffset:titleOffset image:self.sectionImages[i] imageOffset:imageOffset atIndex:i];
        }
    }
    
    [self drawSelectionIndicatorForIndex:self.selectedSegmentIndex];
}

- (void)addLayerForTitle:(NSString *)title titleOffset:(CGPoint)titleOffset image:(UIImage *)image imageOffset:(CGPoint)imageOffset atIndex:(NSInteger)index {
    
    CGFloat titleImageSpacing = (title && image) ? self.titleImageSpacing : 0;
    CGSize imageSize = image ? image.size : CGSizeZero;
    CGSize titleSize = title ? [self sizeOfString:title] : CGSizeZero;
    CGFloat lateralSpacing = ([self.segmentWidths[index] floatValue] - imageSize.width - titleSize.width - titleImageSpacing) / 2;
    CGFloat xOffset = [self xOffsetForIndex:index];
    CGRect imageRect;
    CGRect titleRect;
    
    if (image) {
        CGFloat imageX = xOffset + lateralSpacing + imageOffset.x;
        CGFloat imageY = self.frame.size.height / 2 - imageSize.height / 2 + imageOffset.y;
        imageRect = (CGRect){ .origin = CGPointMake(lroundf(imageX), lroundf(imageY)), .size = imageSize };
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = imageRect;
        imageLayer.contents = (self.selectedSegmentIndex == index) ? (id)[self.sectionSelectedImages[index] CGImage] : (id)[image CGImage];
        [self.layer addSublayer:imageLayer];
    }
    
    if (title) {
        CGFloat textX = xOffset + lateralSpacing + imageSize.width + titleImageSpacing + titleOffset.x;
        CGFloat textY = self.frame.size.height / 2 - titleSize.height / 2 + titleOffset.y;
        titleRect = (CGRect){ .origin = CGPointMake(lroundf(textX), lroundf(textY)), .size = titleSize };
        
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.frame = titleRect;
        titleLayer.font = (__bridge CFTypeRef)(self.font.fontName);
        titleLayer.fontSize = self.font.pointSize;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.string = title;
        titleLayer.truncationMode = kCATruncationEnd;
        titleLayer.foregroundColor = (self.selectedSegmentIndex == index) ? [self.selectedTextColor CGColor] : [self.textColor CGColor];
        titleLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:titleLayer];
    }
    
}

- (void)updateSegmentWidths {
    NSArray *segmentWidths = [self calculateSegmentWidths];
    
    switch (self.segmentWidthStyle) {
        case CCBSegmentedControlSegmentWidthStyleDynamic:
            self.segmentWidths = segmentWidths;
            break;
        case CCBSegmentedControlSegmentWidthStyleFixed:
            self.segmentWidths = [self generateFixedSegmentWithArrayFromSegmentWidth:segmentWidths];
            break;
    }
}

#pragma mark -
#pragma mark - Draw selection indicator

- (CGRect)frameForSelectionIndicatorAtIndex:(NSInteger)index {
    if (!self.segmentWidths || [self.segmentWidths count] == 0) return CGRectZero;
    
    CGPoint origin = [self calculateSelectionIndicatorOriginForIndex:index];
    
    return CGRectMake(origin.x, origin.y, self.selectionIndicatorWidth, self.selectionIndicatorHeight);
}

- (CGPoint)calculateSelectionIndicatorOriginForIndex:(NSInteger)index {
    CGFloat x = 0.0;
    
    if (self.type == CCBSegmentedControlTypeImages || self.type == CCBSegmentedControlTypeText) {
        x = [self xOffsetForIndex:index] + [self.segmentWidths[index] floatValue] / 2;
    } else if (self.type == CCBSegmentedControlTypeTextImages) {
        CGPoint titleOffset = self.titleOffsets[index] ? [self.titleOffsets[index] CGPointValue] : CGPointZero;
        CGFloat imageWidth = [(UIImage *)self.sectionImages[index] size].width;
        CGFloat titleWidth = [self sizeOfString:(NSString *)self.sectionTitles[index]].width;
        CGFloat lateralSpacing = ([self.segmentWidths[index] floatValue] - imageWidth - titleWidth - self.titleImageSpacing) / 2;
        
        x = [self xOffsetForIndex:index] + lateralSpacing + imageWidth + self.titleImageSpacing + titleOffset.x + titleWidth / 2 - self.selectionIndicatorWidth / 2;
    }
    
    CGFloat y = CGRectGetHeight(self.frame) - self.selectionIndicatorHeight + self.selectionIndicatorOffset.y;
    
    return CGPointMake(x, y);
}

- (void)drawSelectionIndicatorForIndex:(NSInteger)index {
    self.selectionIndicatorLayer.frame = [self frameForSelectionIndicatorAtIndex:index];
    self.selectionIndicatorLayer.mask = nil;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGPoint p3 = CGPointZero;
    
    p1 = CGPointMake(CGRectGetWidth(self.selectionIndicatorLayer.bounds) / 2, 0);
    p2 = CGPointMake(0, CGRectGetHeight(self.selectionIndicatorLayer.bounds));
    p3 = CGPointMake(CGRectGetWidth(self.selectionIndicatorLayer.bounds), CGRectGetHeight(self.selectionIndicatorLayer.bounds));
    
    [arrowPath moveToPoint:p1];
    [arrowPath addLineToPoint:p2];
    [arrowPath addLineToPoint:p3];
    [arrowPath closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.selectionIndicatorLayer.bounds;
    maskLayer.path = arrowPath.CGPath;
    self.selectionIndicatorLayer.mask = maskLayer;
    
    [self.layer addSublayer:self.selectionIndicatorLayer];
}

#pragma mark -
#pragma mark - Draw helpers

- (CGFloat)xOffsetForIndex:(NSInteger)index {
    CGFloat offset = 0;
    
    for (NSInteger i = 0; i < index; i++) {
        offset += [self.segmentWidths[i] floatValue];
    }
    
    return offset;
}

- (CGSize)sizeOfString:(NSString *)string {
    CGSize titleSize = [string sizeWithAttributes:@{NSFontAttributeName : self.font}];
    return CGSizeMake(ceilf(titleSize.width), lroundf(titleSize.height));
}

- (NSArray *)generateFixedSegmentWithArrayFromSegmentWidth:(NSArray *)segmentWidths {
    NSMutableArray *fixedSegmentWidths = [NSMutableArray array];
    NSNumber *maxWidth = [segmentWidths valueForKeyPath:@"@max.floatValue"];
    NSInteger segmentCount = [self segmentCount];
    
    for (int i = 0; i < segmentCount; i++) {
        [fixedSegmentWidths addObject:[maxWidth copy]];
    }
    
    return [NSArray arrayWithArray:fixedSegmentWidths];
}

- (NSArray *)calculateSegmentWidths {
    NSMutableArray *segmentWidths = [NSMutableArray array];
    
    if (self.type == CCBSegmentedControlTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL *stop) {
            CGFloat width = 2 * self.minimumLateralPadding + [self sizeOfString:(NSString *)title].width;
            [segmentWidths addObject:[NSNumber numberWithFloat:width]];
        }];
    } else if (self.type == CCBSegmentedControlTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id image, NSUInteger idx, BOOL *stop) {
            CGFloat width = 2 * self.minimumLateralPadding + [(UIImage *)image size].width;
            [segmentWidths addObject:[NSNumber numberWithFloat:width]];
        }];
    } else if (self.type == CCBSegmentedControlTypeTextImages) {
        NSInteger segmentCount = [self segmentCount];
        
        for (NSInteger index = 0; index < segmentCount; index++) {
            CGFloat titleWidth = [self sizeOfString:(NSString *)self.sectionTitles[index]].width;
            CGFloat imageWidth = [(UIImage *)self.sectionImages[index] size].width;
            
            [segmentWidths addObject:[NSNumber numberWithFloat: 2 * self.minimumLateralPadding + imageWidth + self.titleImageSpacing + titleWidth]];
        }
    }
    
    return [NSArray arrayWithArray:segmentWidths];
}

#pragma mark -
#pragma mark - Touch handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = [self segmentIndexAtPoint:touchLocation];
        NSUInteger segmentCount = [self segmentCount];
        
        if (segment != self.selectedSegmentIndex && segment < segmentCount) {
            [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }
    }
}
    
- (NSInteger)segmentIndexAtPoint:(CGPoint)point {
    NSInteger segmentIndex = 0;
    
    if (self.segmentWidthStyle == CCBSegmentedControlSegmentWidthStyleFixed)
    {
        segmentIndex = point.x / [[self.segmentWidths firstObject] floatValue];
    }
    else if (self.segmentWidthStyle == CCBSegmentedControlSegmentWidthStyleDynamic)
    {
        CGFloat remainingWidth = point.x;
        NSInteger segmentCount = [self segmentCount];
        
        for (NSInteger index = 0; index < segmentCount; index++) {
            remainingWidth -= [self.segmentWidths[index] floatValue];
            
            if (remainingWidth <= 0) {
                segmentIndex = index;
                break;
            }
        }
    }
    
    return segmentIndex;
}

#pragma mark -
#pragma mark - Insets

- (void)addTitleOffset:(CGPoint)offset forSegmentAtIndex:(NSInteger)index {
    if (!self.titleOffsets) {
        self.titleOffsets = [NSMutableArray arrayWithCapacity:[self segmentCount]];
    }
    
    [self.titleOffsets insertObject:[NSValue valueWithCGPoint:offset] atIndex:index];
}

- (void)addImageOffset:(CGPoint)offset forSegmentAtIndex:(NSInteger)index {
    if (!self.imageOffsets) {
        self.imageOffsets = [NSMutableArray arrayWithCapacity:[self segmentCount]];
    }
    
    [self.imageOffsets insertObject:[NSValue valueWithCGPoint:offset] atIndex:index];
}

#pragma mark -
#pragma mark - Index change

- (NSInteger)segmentCount {
    switch (self.type) {
        case CCBSegmentedControlTypeText:
            return [self.sectionTitles count];
        case CCBSegmentedControlTypeImages:
        case CCBSegmentedControlTypeTextImages:
            return [self.sectionImages count];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];
    
    self.selectionIndicatorLayer.actions = nil;
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        self.selectionIndicatorLayer.frame = [self frameForSelectionIndicatorAtIndex:index];
        [CATransaction commit];
    } else {
        self.selectionIndicatorLayer.frame = [self frameForSelectionIndicatorAtIndex:index];
    }
    
    if (notify) {
        [self notifyForSegmentChangeToIndex:index];
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    if (self.indexChangeBlock) {
        self.indexChangeBlock(index);
    }
}

@end
