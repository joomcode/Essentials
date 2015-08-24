//
//  NNKeyboardListener.m
//  Essentials
//
//  Created by Nick Tymchenko on 2/2/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "NNKeyboardListener.h"

@interface NNKeyboardListener ()

@property (nonatomic, assign) CGFloat viewCoveredHeight;

@property (nonatomic, assign, getter = isKeyboardVisible) BOOL keyboardVisible;
@property (nonatomic, assign) CGRect lastKeyboardEndFrame;

@property (nonatomic, strong) NSLayoutConstraint *layoutGuideBottomConstraint;

@end


@implementation NNKeyboardListener

#pragma mark Init

- (id)init {
    return [self initWithView:nil];
}

- (id)initWithView:(UIView *)view {
    return [self initWithView:view animationBlock:nil];
}

- (id)initWithView:(UIView *)view animationBlock:(NNKeyboardListenerBlock)animationBlock {
    NSParameterAssert(view != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _view = view;
    _animationBlock = [animationBlock copy];
    _enabled = YES;
    _usesWindowForOrphanView = YES;
    _lastKeyboardEndFrame = CGRectZero;
    
    [self registerForNotifications];
    
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
    [self unregisterFromNotifications];
    
    [_layoutGuide removeFromSuperview];
}

#pragma mark Properties

@synthesize layoutGuide = _layoutGuide;

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        
        if (enabled) {
            [self registerForNotifications];
        } else {
            [self unregisterFromNotifications];
        }
    }
}

- (UIView *)layoutGuide {
    if (!_layoutGuide) {
        _layoutGuide = [[UIView alloc] init];
        _layoutGuide.hidden = YES;
        _layoutGuide.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_layoutGuide];
        
        for (NSNumber *attributeWrapper in @[ @(NSLayoutAttributeTop), @(NSLayoutAttributeLeft), @(NSLayoutAttributeRight) ]) {
            NSLayoutAttribute attribute = (NSLayoutAttribute)[attributeWrapper integerValue];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_layoutGuide
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:attribute
                                                                 multiplier:1
                                                                   constant:0]];
        }
        
        self.layoutGuideBottomConstraint = [NSLayoutConstraint constraintWithItem:_layoutGuide
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-self.viewCoveredHeight];
        [self.view addConstraint:self.layoutGuideBottomConstraint];
    }
    return _layoutGuide;
}

#pragma mark Notifications

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Public

- (void)updateViewCoveredHeight {
    [self updateViewCoveredHeightWithNotification:nil];
}

#pragma mark Private

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.keyboardVisible) return;
    self.keyboardVisible = YES;
    
    [self resizeForKeyboardNotification:notification];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.keyboardVisible) return;
    
    [self resizeForKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.keyboardVisible) return;
    self.keyboardVisible = NO;
    
    [self resizeForKeyboardNotification:notification];
}

- (void)resizeForKeyboardNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    self.lastKeyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    void (^animateAlongsideKeyboard)(void (^)()) = ^(void (^animations)()){
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | [self animationOptionsWithCurve:animationCurve] animations:^{
            animations();
        } completion:nil];
    };
    
    if (_layoutGuide) {
        // Ensures that all pending layout operations have been completed.
        [self.view layoutIfNeeded];
    }
    
    animateAlongsideKeyboard(^{
        // Set viewCoveredHeight inside animation block for benefit of our KVO friends.
        [self updateViewCoveredHeightWithNotification:notification];
        
        if (_layoutGuide) {
            [self.view layoutIfNeeded];
        }
    });
}

- (void)updateViewCoveredHeightWithNotification:(NSNotification *)notification {
    self.viewCoveredHeight = [self viewCoveredHeightForKeyboardFrame:self.lastKeyboardEndFrame];
    
    if (notification && self.animationBlock) {
        self.animationBlock(notification, self.viewCoveredHeight);
    }
    
    if (_layoutGuide) {
        self.layoutGuideBottomConstraint.constant = -self.viewCoveredHeight;
        [self.view setNeedsUpdateConstraints];
    };
}

- (CGFloat)viewCoveredHeightForKeyboardFrame:(CGRect)keyboardFrame {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = nil;
    if ([self.view isDescendantOfView:window]) {
        view = self.view;
    } else if (self.usesWindowForOrphanView) {
        view = window;
    }
    
    if (!view) {
        return 0;
    }
    
    CGRect keyboardFrameInWindow = [window convertRect:keyboardFrame fromView:nil];
    if (CGSizeEqualToSize(CGRectIntersection(window.bounds, keyboardFrameInWindow).size, CGSizeZero)) {
        return 0;
    }
    
    CGRect keyboardFrameInView = [view convertRect:keyboardFrame fromView:nil];
    return MAX(0, CGRectGetMaxY(view.bounds) - CGRectGetMinY(keyboardFrameInView));
}

- (UIViewAnimationOptions)animationOptionsWithCurve:(UIViewAnimationCurve)curve {
    // The undocumented UIViewAnimationCurve value (7) is used for keyboard animation in iOS 7. Thanks, Apple!
    return curve << 16;
}

@end
