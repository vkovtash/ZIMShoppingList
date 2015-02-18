//
//  ZIMAppearanceController.m
//  ShoppingCart
//
//  Created by kovtash on 18.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMAppearanceController.h"
#import "ZIMCartItemTableViewCell.h"
#import "ZIMShoppingListViewController.h"
#import "ZIMCartItemCellConfigurator.h"

@implementation ZIMAppearanceController

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _mainColor = [UIColor blueColor];
        _destructiveColor = [UIColor redColor];
        _laterColor = [UIColor yellowColor];
        _doneColor = [UIColor greenColor];
    }
    return self;
}

+ (instancetype)defaultAppearance {
    static dispatch_once_t pred;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)setTintColor:(UIColor *)tintColor {
    [UIApplication sharedApplication].delegate.window.tintColor = tintColor;
}

- (UIColor *)tintColor {
    return [UIApplication sharedApplication].delegate.window.tintColor;
}

- (void)applyAppearance {
    self.tintColor = self.mainColor;
    
    id appearance = nil;
    
    appearance = [ZIMCartItemCellConfigurator appearance];
    [appearance setDefaultColor:self.backgroundColor];
    [appearance setDoneColor:self.doneColor];
    [appearance setDeleteColor:self.destructiveColor];
    [appearance setMainColor:self.mainColor];
    [appearance setLaterColor:self.laterColor];
    [appearance setLaterImage:[UIImage imageNamed:@"clock"]];
    [appearance setUndoneImage:[UIImage imageNamed:@"list"]];
    [appearance setDeleteImage:[UIImage imageNamed:@"cross"]];
    [appearance setDoneImage:[UIImage imageNamed:@"check"]];
    
    appearance  = [UITableView appearanceWhenContainedIn:[ZIMShoppingListViewController class], nil];
    [appearance setRowHeight:65];
    [appearance setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
}

@end
