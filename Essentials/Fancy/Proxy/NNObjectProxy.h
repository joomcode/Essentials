//
//  NNObjectProxy.h
//  Essentials
//
//  Created by Nick Tymchenko on 24/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNObjectProxy : NSProxy

- (instancetype)initWithObject:(id)object;

@end
