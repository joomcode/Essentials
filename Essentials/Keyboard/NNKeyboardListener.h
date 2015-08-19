//
//  NNKeyboardListener.h
//  Essentials
//
//  Created by Nick Tymchenko on 2/2/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^NNKeyboardListenerBlock)(NSNotification *notification, CGFloat viewCoveredHeight);


@interface NNKeyboardListener : NSObject

@property (nonatomic, weak, readonly) UIView *view;

@property (nonatomic, readonly) CGFloat viewCoveredHeight;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

// Return YES to animate layoutGuide constraints update.
@property (nonatomic, copy) NNKeyboardListenerBlock animationBlock;

// When accessed for the first time, will add a hidden subview to the view.
// Edges of this subview represent portion of the view which is not covered by the keyboard.
@property (nonatomic, strong, readonly) UIView *layoutGuide;

// By default, equals to YES.
// Uses the key window for covered height calculation if the view doesn't belong to its hierarchy yet.
// It is useful when keyboard appears before view has been added to its container (e.g., -viewWillAppear:).
@property (nonatomic, assign) BOOL usesWindowForOrphanView;

- (id)initWithView:(UIView *)view;

- (id)initWithView:(UIView *)view animationBlock:(NNKeyboardListenerBlock)animationBlock NS_DESIGNATED_INITIALIZER;

// Use this method to adapt to view frame changes.
- (void)updateViewCoveredHeight;

@end
