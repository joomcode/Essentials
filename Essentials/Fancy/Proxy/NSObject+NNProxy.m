//
//  NSObject+NNProxy.m
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "NSObject+NNProxy.h"
#import "NNLazyProxy.h"
#import "NNAsyncInitProxy.h"

@implementation NSObject (NNProxy)

+ (instancetype)nn_lazy {
    return (id)[[NNLazyProxy alloc] initWithClass:[self class]];
}

+ (instancetype)nn_lazyInitWithBlock:(id (^)(void))block {
    NSParameterAssert(block != nil);
    return (id)[[NNLazyProxy alloc] initWithClass:[self class] block:block];
}

+ (instancetype)nn_async {
    return (id)[[NNAsyncInitProxy alloc] initWithClass:[self class]];
}

+ (instancetype)nn_asyncInitWithBlock:(id (^)(void))block {
    NSParameterAssert(block != nil);
    return (id)[[NNAsyncInitProxy alloc] initWithClass:[self class] block:block];
}

@end
