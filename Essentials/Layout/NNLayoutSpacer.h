//
//  NNLayoutSpacer.h
//  Essentials
//
//  Created by Nick Tymchenko on 30/11/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNLayoutSpacer : UIView

+ (instancetype)addHorizontalSpacerBetween:(id)firstViewOrAttribute and:(id)secondViewOrAttribute;
+ (instancetype)addVerticalSpacerBetween:(id)firstViewOrAttribute and:(id)secondViewOrAttribute;

@end
