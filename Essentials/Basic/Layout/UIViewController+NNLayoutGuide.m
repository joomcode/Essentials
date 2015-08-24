//
//  UIViewController+NNLayoutGuide.m
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "UIViewController+NNLayoutGuide.h"
#import "NNLayoutSpacer.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@implementation UIViewController (NNLayoutGuide)

static void * const kLayoutGuideKey = (void *)&kLayoutGuideKey;

- (UIView *)nn_layoutGuide {
    UIView *layoutGuide = objc_getAssociatedObject(self, kLayoutGuideKey);
    if (!layoutGuide || !layoutGuide.superview) {
        layoutGuide = [[NNLayoutSpacer alloc] init];
        [self.view addSubview:layoutGuide];
        [layoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((UIView *)self.topLayoutGuide).mas_bottom);
            make.bottom.equalTo(((UIView *)self.bottomLayoutGuide).mas_top);
            make.left.and.right.equalTo(self.view);
        }];
        
        objc_setAssociatedObject(self, kLayoutGuideKey, layoutGuide, OBJC_ASSOCIATION_RETAIN);
    }
    return layoutGuide;
}

@end
