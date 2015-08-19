//
//  UIScrollView+NNKeyboardListener.m
//  Essentials
//
//  Created by Nick Tymchenko on 2/2/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "UIScrollView+NNKeyboardListener.h"
#import "NNKeyboardListener.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (nonatomic, assign) CGFloat nn_keyboardCoveredHeight;

@property (nonatomic, strong) NNKeyboardListener *nn_keyboardListener;

@end


@implementation UIScrollView (NNKeyboardListener)

#pragma mark Properties

static const char kKeyboardCoveredHeightKey;
static const char kKeyboardListenerKey;

- (CGFloat)nn_keyboardCoveredHeight {
    NSNumber *wrapper = objc_getAssociatedObject(self, &kKeyboardCoveredHeightKey);
    return [wrapper doubleValue];
}

- (void)setNn_keyboardCoveredHeight:(CGFloat)keyboardCoveredHeight {
    NSNumber *wrapper = [NSNumber numberWithDouble:keyboardCoveredHeight];
    objc_setAssociatedObject(self, &kKeyboardCoveredHeightKey, wrapper, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NNKeyboardListener *)nn_keyboardListener {
    return objc_getAssociatedObject(self, &kKeyboardListenerKey);
}

- (void)setNn_keyboardListener:(NNKeyboardListener *)keyboardListener {
    objc_setAssociatedObject(self, &kKeyboardListenerKey, keyboardListener, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Public

- (BOOL)nn_adjustsInsetsForKeyboard {
    return self.nn_keyboardListener != nil;
}

- (void)setNn_adjustsInsetsForKeyboard:(BOOL)adjustsInsetsForKeyboard {
    if (adjustsInsetsForKeyboard && !self.nn_keyboardListener) {
        self.nn_keyboardCoveredHeight = 0;
        
        __weak typeof(self) weakSelf = self;
        self.nn_keyboardListener = [[NNKeyboardListener alloc] initWithView:self animationBlock:^(NSNotification* notification, CGFloat viewCoveredHeight) {
            CGFloat bottomInsetDiff = viewCoveredHeight - weakSelf.nn_keyboardCoveredHeight;
            weakSelf.nn_keyboardCoveredHeight = viewCoveredHeight;
            
            UIEdgeInsets contentInset = weakSelf.contentInset;
            contentInset.bottom += bottomInsetDiff;
            weakSelf.contentInset = contentInset;
            
            UIEdgeInsets scrollIndicatorInsets = weakSelf.scrollIndicatorInsets;
            scrollIndicatorInsets.bottom += bottomInsetDiff;
            weakSelf.scrollIndicatorInsets = scrollIndicatorInsets;
        }];
    } else if (!adjustsInsetsForKeyboard) {
        self.nn_keyboardListener = nil;
    }
}

@end
