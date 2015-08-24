//
//  NNTouchInterceptorView.h
//  Essentials
//
//  Created by Nick Tymchenko on 5/15/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNTouchInterceptorView : UIView

@property (nonatomic, copy) NSSet *exceptionViews;
@property (nonatomic, copy) NSSet *exceptionClasses;

@property (nonatomic, assign, getter = isTransparent) BOOL transparent;

@property (nonatomic, copy) void (^willTouchExceptionView)(UIView *touchedView);
@property (nonatomic, copy) void (^touchesBegan)(NSSet *touches);
@property (nonatomic, copy) void (^touchesEnded)(NSSet *touches);

@end