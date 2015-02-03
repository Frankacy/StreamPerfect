//
//  UIImage+IconAndTextHeader.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-04-28.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (IconAndTextHeader)

+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color;
+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color font:(UIFont *)font;
+ (id) imageFromImage:(UIImage *)image string:(NSString *)string color:(UIColor *)color font:(UIFont *)font imageInset:(UIEdgeInsets)imageInsets textInset:(UIEdgeInsets)textInsets;

@end
