//
//  NNAsyncInitProxy.m
//  Essentials
//
//  Created by Nick Tymchenko on 24/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import "NNAsyncInitProxy.h"

@implementation NNAsyncInitProxy

- (void)_didBecomeAbleToInstantiateObject {
    [super _didBecomeAbleToInstantiateObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self _instantiateObjectIfNeeded];
    });
}

@end
