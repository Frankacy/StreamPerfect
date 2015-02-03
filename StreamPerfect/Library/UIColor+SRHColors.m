//
//  UIColor+SRHColors.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "UIColor+SRHColors.h"

@implementation UIColor (SRHColors)

+ (UIColor *)srhPurpleColor {
    return [UIColor colorWithRed:0.6 green:0.2 blue:1 alpha:1];
}

+ (UIColor *)srhTurquoiseColor {
    return [UIColor colorWithRed:0.4705 green:1 blue:0.7450 alpha:1];
}

+ (UIColor *)srhOrangeColor {
    return [UIColor colorWithRed:0.98 green:0.7 blue:0.2 alpha:1];
}

+ (UIColor *)srhGrayTextColor {
    return [UIColor colorWithRed:0.4352 green:0.4039 blue:0.4667 alpha:1];
}

+ (UIColor *)srhTableSeparatorColor {
//    return [UIColor colorWithRed:0.4352 green:0.4039 blue:0.4667 alpha:0.5];
    return [UIColor colorWithRed:0.874 green:0.874 blue:0.874 alpha:1];
}

+ (UIColor *)srhLightGrayColor {
    return [UIColor colorWithWhite:246.0/255 alpha:1.0];
}

+ (UIColor *)srhDarkBlueColor {
    return [UIColor colorWithRed:0.149 green:0.329 blue:0.51 alpha:1.0];
}

+ (UIColor *)srhBlueGrayColor {
    return [UIColor colorWithRed:0.38 green:0.427 blue:0.529 alpha:1.0];
}

+ (UIColor *)srhMediumGrayColor {
    return [UIColor colorWithWhite:234.0/255 alpha:1.0];
}

@end