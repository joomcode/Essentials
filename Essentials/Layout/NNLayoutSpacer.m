//
//  NNLayoutSpacer.m
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "NNLayoutSpacer.h"
#import <Masonry/Masonry.h>

@implementation NNLayoutSpacer

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void)commonInit {
    self.hidden = YES;
    self.userInteractionEnabled = NO;
}

#pragma mark - Public

+ (instancetype)addHorizontalSpacerBetween:(id)firstViewOrAttribute and:(id)secondViewOrAttribute {
    NNLayoutSpacer *spacer = [self addSpacerForViewOrAttibute:firstViewOrAttribute andViewOrAttribute:secondViewOrAttribute];
    
    if ([firstViewOrAttribute isKindOfClass:[UIView class]]) {
        firstViewOrAttribute = ((UIView *)firstViewOrAttribute).mas_right;
    }
    if ([secondViewOrAttribute isKindOfClass:[UIView class]]) {
        secondViewOrAttribute = ((UIView *)secondViewOrAttribute).mas_left;
    }
    
    [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstViewOrAttribute);
        make.right.equalTo(secondViewOrAttribute);
        make.top.and.bottom.equalTo(spacer.superview).with.priority(100);
    }];
    
    return spacer;
}

+ (instancetype)addVerticalSpacerBetween:(id)firstViewOrAttribute and:(id)secondViewOrAttribute {
    NNLayoutSpacer *spacer = [self addSpacerForViewOrAttibute:firstViewOrAttribute andViewOrAttribute:secondViewOrAttribute];
    
    if ([firstViewOrAttribute isKindOfClass:[UIView class]]) {
        firstViewOrAttribute = ((UIView *)firstViewOrAttribute).mas_bottom;
    }
    if ([secondViewOrAttribute isKindOfClass:[UIView class]]) {
        secondViewOrAttribute = ((UIView *)secondViewOrAttribute).mas_top;
    }
    
    [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstViewOrAttribute);
        make.bottom.equalTo(secondViewOrAttribute);
        make.left.and.right.equalTo(spacer.superview).with.priority(100);
    }];
    
    return spacer;
}

#pragma mark - Private

+ (instancetype)addSpacerForViewOrAttibute:(id)firstViewOrAttribute andViewOrAttribute:(UIView *)secondViewOrAttribute {
    UIView *firstView = [self viewWithViewOrAttribute:firstViewOrAttribute];
    UIView *secondView = [self viewWithViewOrAttribute:secondViewOrAttribute];
    
    UIView *parent = [self findCommonAncestorForView:firstView andView:secondView];
    NSAssert(parent != nil, @"Views should have common ancestor!");
    
    NNLayoutSpacer *spacer = [[NNLayoutSpacer alloc] init];
    [parent addSubview:spacer];
    return spacer;
}

+ (UIView *)viewWithViewOrAttribute:(id)viewOrAttribute {
    if ([viewOrAttribute isKindOfClass:[UIView class]]) {
        return viewOrAttribute;
    }
    if ([viewOrAttribute isKindOfClass:[MASViewAttribute class]]) {
        return ((MASViewAttribute *)viewOrAttribute).view;
    }
    NSAssert(NO, @"Expected UIView or MASViewAttribute, got %@", viewOrAttribute);
    return nil;
}

+ (UIView *)findCommonAncestorForView:(UIView *)view1 andView:(UIView *)view2 {
    while (view1 != nil) {
        if ([view2 isDescendantOfView:view1]) {
            return view1;
        }
        view1 = view1.superview;
    }
    return nil;
}

@end
