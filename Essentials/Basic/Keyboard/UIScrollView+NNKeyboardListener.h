//
//  UIScrollView+NNKeyboardListener.h
//  Essentials
//
//  Created by Nick Tymchenko on 2/2/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (NNKeyboardListener)

@property (nonatomic, assign) BOOL nn_adjustsInsetsForKeyboard;

@property (nonatomic, assign, readonly) CGFloat nn_keyboardCoveredHeight;

@end
