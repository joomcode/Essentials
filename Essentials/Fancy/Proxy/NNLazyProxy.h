//
//  NNLazyProxy.h
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNObjectProxy.h"

NS_ASSUME_NONNULL_BEGIN

typedef id (^NNLazyProxyInitBlock)(void);

@interface NNLazyProxy : NSProxy 

- (instancetype)initWithClass:(Class)aClass;
- (instancetype)initWithClass:(Class)aClass block:(nullable NNLazyProxyInitBlock)block;

- (void)_instantiateObjectIfNeeded;
- (void)_didBecomeAbleToInstantiateObject;

@end

NS_ASSUME_NONNULL_END