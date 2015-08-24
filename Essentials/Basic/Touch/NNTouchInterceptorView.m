//
//  NNTouchInterceptorView.m
//  Essentials
//
//  Created by Nick Tymchenko on 5/15/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "NNTouchInterceptorView.h"

@interface NNTouchInterceptorView ()

@property (nonatomic, assign) BOOL hitTestDisabled;
@property (nonatomic, strong) NSMutableSet *exceptionViewTouchEventTimestamps;

@end


@implementation NNTouchInterceptorView

#pragma mark - UIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self hasExceptionViews]) {
        if (self.hitTestDisabled) {
            return nil;
        }
        
        // Let's temporarily disable hit test detection for self and retry hitTest:withEvent: for our superview
        // to check if we actually could hit any of our exception views or their subviews.
        
        self.hitTestDisabled = YES;
        
        CGPoint pointInSuperview = [self convertPoint:point toView:self.superview];
        UIView *view = [self.superview hitTest:pointInSuperview withEvent:event];
        
        self.hitTestDisabled = NO;
        
        if (self.transparent) {
            [self willTouchExceptionView:view withEvent:event];
            return nil;
        }
        
        for (UIView *exceptionView in self.exceptionViews) {
            if ([view isDescendantOfView:exceptionView]) {
                [self willTouchExceptionView:view withEvent:event];
                return nil;
            }
        }
        
        if ([self.exceptionClasses count] > 0) {
            UIView *currentView = view;
            while (currentView != self.superview) {
                for (Class exceptionClass in self.exceptionClasses) {
                    if ([currentView isKindOfClass:exceptionClass]) {
                        [self willTouchExceptionView:view withEvent:event];
                        return nil;
                    }
                }
                currentView = currentView.superview;
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.touchesBegan) {
        self.touchesBegan(touches);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.touchesEnded) {
        self.touchesEnded(touches);
    }
}

#pragma mark - Private

- (BOOL)hasExceptionViews {
    return self.transparent || [self.exceptionViews count] > 0 || [self.exceptionClasses count] > 0;
}

- (NSMutableSet *)exceptionViewTouchEventTimestamps {
    if (!_exceptionViewTouchEventTimestamps) {
        _exceptionViewTouchEventTimestamps = [[NSMutableSet alloc] init];
    }
    return _exceptionViewTouchEventTimestamps;
}

- (void)willTouchExceptionView:(UIView *)view withEvent:(UIEvent *)event {
    if ([self.exceptionViewTouchEventTimestamps containsObject:@(event.timestamp)]) return;
    [self.exceptionViewTouchEventTimestamps addObject:@(event.timestamp)];
    
    if (self.willTouchExceptionView) {
        self.willTouchExceptionView(view);
    }
}

@end
