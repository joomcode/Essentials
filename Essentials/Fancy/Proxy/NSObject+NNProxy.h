//
//  NSObject+NNProxy.h
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//
//  Based loosely on http://andyarvanitis.com/lazy-initialization-for-objective-c/
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NNProxy)

+ (instancetype)nn_lazy;
+ (instancetype)nn_lazyInitWithBlock:(id (^)(void))block;

+ (instancetype)nn_async;
+ (instancetype)nn_asyncInitWithBlock:(id (^)(void))block;

@end

NS_ASSUME_NONNULL_END