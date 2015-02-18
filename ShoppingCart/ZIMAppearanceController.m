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

@implementation ZIMAppearanceController

+ (instancetype)defaultAppearance {
    static dispatch_once_t pred;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)applyAppearance {
    id appearance = nil;
    
    appearance  = [UITableView appearanceWhenContainedIn:[ZIMShoppingListViewController class], nil];
    [appearance setRowHeight:65];
    [appearance setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
}

@end
