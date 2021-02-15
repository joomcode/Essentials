//
//  NNScrollViewWrapper.m
//  Essentials
//
//  Created by Nick Tymchenko on 10/02/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "NNScrollViewWrapper.h"
@import Masonry;

@interface NNScrollViewContentView : UIView

@property (nonatomic, weak, readonly) UIScrollView *hostView;

@end


@implementation NNScrollViewContentView

- (instancetype)initWithHostView:(UIScrollView *)hostView
{
    self = [super init];
    if (!self) return nil;
    
    _hostView = hostView;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.hostView.contentSize = self.bounds.size;
}

@end


@interface NNScrollViewWrapper ()

@property (nonatomic, strong) MASConstraint *contentSizeConstraint;

@end


@implementation NNScrollViewWrapper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void)commonInit
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];

    _contentView = [[NNScrollViewContentView alloc] initWithHostView:_scrollView];
    [_scrollView addSubview:_contentView];
    
    _contentSizePriority = UILayoutPriorityDefaultHigh;
    
    [self setupConstraints];
    [self setNeedsUpdateConstraints];
}

- (void)setupConstraints
{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self->_scrollView);
    }];
}

- (void)updateConstraints
{
    [self.contentSizeConstraint uninstall];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.contentSizeConstraint = make.size.equalTo(self.contentView).with.priority(self.contentSizePriority);
    }];
    
    [super updateConstraints];
}

- (void)setContentSizePriority:(UILayoutPriority)contentSizePriority
{
    if (_contentSizePriority != contentSizePriority) {
        _contentSizePriority = contentSizePriority;
        [self setNeedsUpdateConstraints];
    }
}

@end
