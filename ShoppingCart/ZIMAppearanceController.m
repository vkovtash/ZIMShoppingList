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
#import "ZIMGoodsCatalogViewController.h"
#import "ZIMCartItemPlaceholderCell.h"

@implementation ZIMAppearanceController

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _mainColor = [UIColor colorWithRed:.3 green:0.65 blue:.95 alpha:1.];
        _destructiveColor = [UIColor colorWithRed:.90 green:0.31 blue:.26 alpha:1.];
        _laterColor = [UIColor colorWithRed:.94 green:0.76 blue:.19 alpha:1.];
        _doneColor = [UIColor colorWithRed:.22 green:0.80 blue:.45 alpha:1.];
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
    
    //ZIMCartItemCellConfigurator
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
    
    //ZIMShoppingListViewController
    appearance  = [UITableView appearanceWhenContainedIn:[ZIMShoppingListViewController class], nil];
    [appearance setRowHeight:65];
    [appearance setBackgroundColor:self.backgroundColor];
    [appearance setTableFooterView:[UIView new]];
    [appearance setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    
    appearance = [ZIMCartItemPlaceholderCell appearanceWhenContainedIn:[ZIMShoppingListViewController class], nil];
    [appearance setBackgroundColor:self.backgroundColor];
    
    //ZIMGoodsCatalogViewController
    appearance = [UITableView appearanceWhenContainedIn:[ZIMGoodsCatalogViewController class], nil];
    [appearance setRowHeight:50];
    [appearance setSectionHeaderHeight:35];
    [appearance setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    
    appearance = [UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], [ZIMGoodsCatalogViewController class], nil];
    [appearance setTextColor:[UIColor darkGrayColor]];
    [appearance setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
}

@end
