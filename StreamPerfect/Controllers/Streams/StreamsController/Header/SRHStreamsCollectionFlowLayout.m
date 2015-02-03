//
//  SRHStreamsCollectionFlowLayout.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-29.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamsCollectionFlowLayout.h"

@implementation SRHStreamsCollectionFlowLayout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attribute in originalAttributes) {
        if (attribute.representedElementKind == UICollectionElementKindSectionHeader) {
            UICollectionViewLayoutAttributes *newAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:attribute.indexPath];
            [newAttributes addObject:newAttribute];
        } else {
            [newAttributes addObject:attribute];
        }
    }
    
    return newAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attr = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        CGRect cellFrame = CGRectMake(50, 33, 244, 25);
        attr.frame = cellFrame;
    } else if (indexPath.section == 1) {
        CGRect cellFrame = CGRectMake(0, 360, 1024, 50);
        attr.frame = cellFrame;
    }
    
    return attr;
}

@end
