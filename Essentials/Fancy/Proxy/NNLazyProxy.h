//
//  NNLazyProxy.h
//  Essentials
//
//  Created by Nick Tymchenko on 23/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNObjectProxy.h"

@interface NNLazyProxy : NSProxy 

- (instancetype)initWithClass:(Class)aClass;

- (void)_instantiateObjectIfNeeded;
- (void)_didCaptureInitInvocation;

@end
