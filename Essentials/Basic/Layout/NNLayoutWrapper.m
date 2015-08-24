//
//  NNLayoutWrapper.m
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "NNLayoutWrapper.h"

typedef NS_OPTIONS(NSInteger, NNLayoutWrapperConstraintType) {
    NNLayoutWrapperConstraintTypeHorizontal = 1 << 0,
    NNLayoutWrapperConstraintTypeExpanded = 1 << 1,
};


@interface NNLayoutWrapper ()

@property (nonatomic, strong) NSMutableDictionary *constraintsByType;
@property (nonatomic, assign) BOOL insetsDidChange;

@end


@implementation NNLayoutWrapper

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithView:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithView:nil];
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithView:view insets:UIEdgeInsetsZero];
}

- (instancetype)initWithView:(UIView *)view insets:(UIEdgeInsets)insets {
    NSParameterAssert(view != nil);
    
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _view = view;
    _view.translatesAutoresizingMaskIntoConstraints = NO;
    [_view addObserver:self forKeyPath:@"alpha" options:0 context:kViewVisibilityKVOContext];
    [_view addObserver:self forKeyPath:@"hidden" options:0 context:kViewVisibilityKVOContext];
    
    _insets = insets;
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [_view removeObserver:self forKeyPath:@"alpha" context:kViewVisibilityKVOContext];
    [_view removeObserver:self forKeyPath:@"hidden" context:kViewVisibilityKVOContext];
}

#pragma mark - Public

- (void)setInsets:(UIEdgeInsets)insets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insets, insets)) {
        _insets = insets;
        self.insetsDidChange = YES;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setCollapsesHorizontallyIfViewIsNotVisible:(BOOL)collapsesHorizontallyIfViewIsNotVisible {
    if (_collapsesHorizontallyIfViewIsNotVisible != collapsesHorizontallyIfViewIsNotVisible) {
        _collapsesHorizontallyIfViewIsNotVisible = collapsesHorizontallyIfViewIsNotVisible;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setCollapsesVerticallyIfViewIsNotVisible:(BOOL)collapsesVerticallyIfViewIsNotVisible {
    if (_collapsesVerticallyIfViewIsNotVisible != collapsesVerticallyIfViewIsNotVisible) {
        _collapsesVerticallyIfViewIsNotVisible = collapsesVerticallyIfViewIsNotVisible;
        [self setNeedsUpdateConstraints];
    }
}

+ (instancetype)addWrapperForView:(UIView *)view withInsets:(UIEdgeInsets)insets {
    NSParameterAssert(view.superview != nil);
    
    NNLayoutWrapper *wrapper = [[NNLayoutWrapper alloc] initWithView:view insets:insets];
    [view.superview addSubview:wrapper];
    return wrapper;
}

+ (instancetype)addCollapsingWrapperForView:(UIView *)view withInsets:(UIEdgeInsets)insets {
    NSParameterAssert(view.superview != nil);
    
    NNLayoutWrapper *wrapper = [[NNLayoutWrapper alloc] initWithView:view insets:insets];
    wrapper.collapsesHorizontallyIfViewIsNotVisible = YES;
    wrapper.collapsesVerticallyIfViewIsNotVisible = YES;
    [view.superview addSubview:wrapper];
    return wrapper;
}

#pragma mark - KVO

static void * const kViewVisibilityKVOContext = (void *)&kViewVisibilityKVOContext;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &kViewVisibilityKVOContext) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    if (self.collapsesHorizontallyIfViewIsNotVisible || self.collapsesVerticallyIfViewIsNotVisible) {
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - UIView

- (void)updateConstraints {
    if (self.insetsDidChange) {
        self.insetsDidChange = NO;
        
        for (NSArray *constraints in [self.constraintsByType allValues]) {
            [self.superview removeConstraints:constraints];
        }
        [self.constraintsByType removeAllObjects];
    }
    
    if (self.collapsesHorizontallyIfViewIsNotVisible && [self viewIsNotVisible]) {
        [self activateConstraintsForType:NNLayoutWrapperConstraintTypeHorizontal];
    } else {
        [self activateConstraintsForType:NNLayoutWrapperConstraintTypeHorizontal | NNLayoutWrapperConstraintTypeExpanded];
    }
    
    if (self.collapsesVerticallyIfViewIsNotVisible & [self viewIsNotVisible]) {
        [self activateConstraintsForType:0];
    } else {
        [self activateConstraintsForType:NNLayoutWrapperConstraintTypeExpanded];
    }
    
    [super updateConstraints];
}

#pragma mark - Private

- (BOOL)viewIsNotVisible {
    return self.view.hidden || self.view.alpha <= 0.01;
}

- (NSMutableDictionary *)constraintsByType {
    if (!_constraintsByType) {
        _constraintsByType = [[NSMutableDictionary alloc] init];
    }
    return _constraintsByType;
}

- (NSArray *)createConstraintsForType:(NNLayoutWrapperConstraintType)constraintType {
    NSLayoutAttribute centerAttribute, sizeAttribute;
    CGFloat centerConstant, sizeConstant;
    
    if (constraintType & NNLayoutWrapperConstraintTypeHorizontal) {
        centerAttribute = NSLayoutAttributeCenterX;
        sizeAttribute = NSLayoutAttributeWidth;
    } else {
        centerAttribute = NSLayoutAttributeCenterY;
        sizeAttribute = NSLayoutAttributeHeight;
    }
    
    if (constraintType & NNLayoutWrapperConstraintTypeExpanded) {
        if (constraintType & NNLayoutWrapperConstraintTypeHorizontal) {
            centerConstant = (self.insets.right - self.insets.left) / 2;
            sizeConstant = self.insets.left + self.insets.right;
        } else {
            centerConstant = (self.insets.bottom - self.insets.top) / 2;
            sizeConstant = self.insets.top + self.insets.bottom;
        }
    } else {
        centerConstant = 0;
        sizeConstant = 0;
    }
    
    return @[
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:centerAttribute
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:centerAttribute
                                    multiplier:1
                                      constant:centerConstant],
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:sizeAttribute
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:(constraintType & NNLayoutWrapperConstraintTypeExpanded) ? self.view : nil
                                     attribute:(constraintType & NNLayoutWrapperConstraintTypeExpanded) ? sizeAttribute : NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:sizeConstant]
    ];
}

- (void)activateConstraintsForType:(NNLayoutWrapperConstraintType)constraintType {
    [self setConstraintsForType:constraintType ^ NNLayoutWrapperConstraintTypeExpanded active:NO];
    [self setConstraintsForType:constraintType active:YES];
}

- (void)setConstraintsForType:(NNLayoutWrapperConstraintType)constraintType active:(BOOL)active {
    NSArray *constraints = self.constraintsByType[@(constraintType)];
    
    if ([[self class] canDeactivateConstraints] && constraints) {
        for (NSLayoutConstraint *constraint in constraints) {
            constraint.active = active;
        }
        return;
    }
    
    if (active && !constraints) {
        constraints = [self createConstraintsForType:constraintType];
        [self.superview addConstraints:constraints];
        self.constraintsByType[@(constraintType)] = constraints;
    } else if (!active && constraints) {
        [self.superview removeConstraints:constraints];
        [self.constraintsByType removeObjectForKey:@(constraintType)];
    }
}

+ (BOOL)canDeactivateConstraints {
    static BOOL canDeactivate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        canDeactivate = [NSLayoutConstraint instancesRespondToSelector:@selector(setActive:)];
    });
    return canDeactivate;
}

@end
