//
//  NNLazyProxy.h
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNObjectProxy.h"

typedef id (^NNLazyProxyInitBlock)();

@interface NNLazyProxy : NSProxy 

- (instancetype)initWithClass:(Class)aClass;
- (instancetype)initWithClass:(Class)aClass block:(NNLazyProxyInitBlock)block;

- (void)_instantiateObjectIfNeeded;
- (void)_didBecomeAbleToInstantiateObject;

@end
