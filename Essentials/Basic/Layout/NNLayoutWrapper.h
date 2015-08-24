//
//  NNLayoutWrapper.h
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNLayoutWrapper : UIView

@property (nonatomic, readonly) UIView *view;

@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, assign) BOOL collapsesHorizontallyIfViewIsNotVisible;
@property (nonatomic, assign) BOOL collapsesVerticallyIfViewIsNotVisible;

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view insets:(UIEdgeInsets)insets;

+ (instancetype)addWrapperForView:(UIView *)view withInsets:(UIEdgeInsets)insets;
+ (instancetype)addCollapsingWrapperForView:(UIView *)view withInsets:(UIEdgeInsets)insets;

@end
