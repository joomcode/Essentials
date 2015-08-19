//
//  NNScrollViewWrapper.h
//  Essentials
//
//  Created by Nick Tymchenko on 10/02/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNScrollViewWrapper : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, assign) UILayoutPriority contentSizePriority; // default = UILayoutPriorityDefaultHigh

@end
