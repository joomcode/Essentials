//
//  UIView+NNSystemLayoutSize.m
//  Essentials
//
//  Created by Nick Tymchenko on 24/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "UIView+NNSystemLayoutSize.h"

@implementation UIView (NNSystemLayoutSize)

- (CGSize)nn_systemLayoutSizeFittingSpecificSize:(CGSize)targetSize withRelation:(NSLayoutRelation)relation {
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:2];
    
    if (targetSize.width > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:relation
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:targetSize.width]];
    }
    
    if (targetSize.height > 0) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:relation
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:targetSize.height]];
    }
    
    [self addConstraints:constraints];
    CGSize systemLayoutSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self removeConstraints:constraints];
    
    return systemLayoutSize;
}

@end
