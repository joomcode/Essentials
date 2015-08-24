//
//  NNObjectProxy.m
//  Essentials
//
//  Created by Nick Tymchenko on 24/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "NNObjectProxy.h"

@implementation NNObjectProxy {
@protected
    id _object;
}

#pragma mark - Init

- (instancetype)initWithObject:(id)object {
    _object = object;
    return self;
}

#pragma mark - NSProxy

- (id)forwardingTargetForSelector:(SEL)selector {
    return _object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [_object methodSignatureForSelector:selector];
}

#pragma mark - NSObject protocol

- (BOOL)isEqual:(id)obj {
    return [_object isEqual:obj];
}

- (NSUInteger)hash {
    return [_object hash];
}

- (Class)superclass {
    return [_object superclass];
}

- (Class)class {
    return [_object class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_object isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_object isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_object conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [_object respondsToSelector:selector];
}

- (NSString *)description {
    return [_object description];
}

@end
