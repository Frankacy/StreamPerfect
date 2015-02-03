//
//  UIImage+IconAndTextHeader.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-28.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "UIImage+IconAndTextHeader.h"

@implementation UIImage (IconAndTextHeader)

+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color {
    return [UIImage imageFromImage:image string:string color:color font:[UIFont systemFontOfSize:12.0] imageInset:UIEdgeInsetsMake(0, 0, 0, 0) textInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    return [UIImage imageFromImage:image string:string color:color font:font imageInset:UIEdgeInsetsMake(0, 0, 0, 0) textInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color font:(UIFont *)font imageInset:(UIEdgeInsets)imageInsets textInset:(UIEdgeInsets)textInsets {
    
    NSDictionary *textAttributes = @{ NSForegroundColorAttributeName : color,
                                      NSFontAttributeName : font };
    CGSize expectedTextSize = [string sizeWithAttributes:textAttributes];
    
    NSInteger width = expectedTextSize.width + image.size.width + 5;
    NSInteger height = MAX(expectedTextSize.height, image.size.width);
    
    CGSize size = CGSizeMake((CGFloat)width, (CGFloat)height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    int fontTopPosition = (height - expectedTextSize.height) / 2;
    CGPoint textPoint = CGPointMake(image.size.width + 5, fontTopPosition);
    
    [string drawAtPoint:textPoint withAttributes:textAttributes];
    
    // Images upside down so flip them
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0, (height - image.size.height) / 2}, {image.size.width, image.size.height} }, [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end