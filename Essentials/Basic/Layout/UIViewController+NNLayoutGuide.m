//
//  UIViewController+NNLayoutGuide.m
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "UIViewController+NNLayoutGuide.h"
#import <objc/runtime.h>

@implementation UIViewController (NNLayoutGuide)

- (UIView *)nn_layoutGuide {
    UIView *layoutGuide = objc_getAssociatedObject(self, _cmd);
    if (!layoutGuide || !layoutGuide.superview) {
        layoutGuide = [[UIView alloc] init];
        layoutGuide.userInteractionEnabled = NO;
        layoutGuide.hidden = YES;
        layoutGuide.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:layoutGuide];
        
        NSArray *constraints = @[
            [NSLayoutConstraint constraintWithItem:layoutGuide
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.topLayoutGuide
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:0.0],
            
            [NSLayoutConstraint constraintWithItem:layoutGuide
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.bottomLayoutGuide
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:0.0],
            
            [NSLayoutConstraint constraintWithItem:layoutGuide
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:0.0],
            
            [NSLayoutConstraint constraintWithItem:layoutGuide
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:0.0]
        ];
        
        [self.view addConstraints:constraints];
        
        objc_setAssociatedObject(self, _cmd, layoutGuide, OBJC_ASSOCIATION_RETAIN);
    }
    return layoutGuide;
}

@end
