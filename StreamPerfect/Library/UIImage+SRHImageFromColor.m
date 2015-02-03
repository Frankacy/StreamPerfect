//
//  UIImage+SRHImageFromColor.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-07.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "UIImage+SRHImageFromColor.h"

@implementation UIImage (SRHImageFromColor)

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
