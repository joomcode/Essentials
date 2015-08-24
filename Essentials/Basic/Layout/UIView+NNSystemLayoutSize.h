//
//  UIView+NNSystemLayoutSize.h
//  Essentials
//
//  Created by Nick Tymchenko on 24/08/15.
//  Copyright (c) 2015 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNSystemLayoutSize)

- (CGSize)nn_systemLayoutSizeFittingSpecificSize:(CGSize)targetSize withRelation:(NSLayoutRelation)relation;

@end
