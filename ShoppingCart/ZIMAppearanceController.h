//
//  ZIMAppearanceController.h
//  ShoppingCart
//
//  Created by kovtash on 18.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZIMAppearanceController : NSObject
@property (readonly, nonatomic) UIColor *backgroundColor;
@property (readonly, nonatomic) UIColor *mainColor;
@property (readonly, nonatomic) UIColor *laterColor;
@property (readonly, nonatomic) UIColor *doneColor;
@property (readonly, nonatomic) UIColor *destructiveColor;
@property (readwrite, nonatomic) UIColor *tintColor;

- (void)applyAppearance;

+ (instancetype)defaultAppearance;
@end
