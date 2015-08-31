//
//  NNLazyProxy.m
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "NNLazyProxy.h"

@implementation NNLazyProxy {
@protected
    volatile id _object;
    Class _objectClass;
    NSInvocation *_initInvocation;
    dispatch_semaphore_t _initSemaphore;
}

#pragma mark - Init

- (instancetype)initWithClass:(Class)aClass {
    _objectClass = aClass;
    _initSemaphore = dispatch_semaphore_create(1);
    return self;
}

#pragma mark - Instantiation

- (void)_instantiateObjectIfNeeded {
    if (_object) {
        return;
    }
    
    if (dispatch_semaphore_wait(_initSemaphore, DISPATCH_TIME_NOW) == 0) {
        id object = [_objectClass alloc];
        
        if (_initInvocation) {
            [_initInvocation invokeWithTarget:object];
            [_initInvocation getReturnValue:&object];
            _initInvocation = nil;
            
            _object = object;
        } else {
            _object = [object init];
        }
        
        dispatch_semaphore_signal(_initSemaphore);
    } else {
        dispatch_semaphore_wait(_initSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(_initSemaphore);
    }
}

#pragma mark - Subclassing hooks

- (void)_didCaptureInitInvocation {
}

#pragma mark - NSProxy

- (id)forwardingTargetForSelector:(SEL)selector {
    if (!_object) {
        if (![NSStringFromSelector(selector) hasPrefix:@"init"]) {
            [self _instantiateObjectIfNeeded];
        }
    }
    return _object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [_objectClass instanceMethodSignatureForSelector:selector];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // If we got here, it had to be from an init method
    
    _initInvocation = invocation;
    [_initInvocation setTarget:nil]; // not needed, and we don't want to retain
    [_initInvocation retainArguments];
    // For the immediate init(With...) call, return the proxy itself
    [_initInvocation setReturnValue:(void *)&self];
    
    [self _didCaptureInitInvocation];
}

#pragma mark - NSObject protocol

- (BOOL)isEqual:(id)obj {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object isEqual:obj];
}

- (NSUInteger)hash {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object hash];
}

- (Class)superclass {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object superclass];
}

- (Class)class {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)selector {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object respondsToSelector:selector];
}

- (NSString *)description {
    if (!_object) {
        [self _instantiateObjectIfNeeded];
    }
    return [_object description];
}

@end
