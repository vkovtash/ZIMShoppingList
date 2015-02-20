//
//  ZIMListItemCellConfigurator.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMListItemCellConfigurator.h"
#import "ZIMListItemUndoneCellConfigurator.h"
#import "ZIMListItemDoneCellConfigurator.h"
#import "ZIMListItemLaterCellConfigurator.h"

@implementation ZIMListItemCellConfigurator

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.firstTrigger = 0.25;
    self.secondTrigger = 0.5;
    self.defaultColor = [UIColor whiteColor];
    self.mainColor = [UIColor blueColor];
    self.doneColor = [UIColor greenColor];
    self.laterColor = [UIColor yellowColor];
    self.deleteColor = [UIColor redColor];
    
    [[[self class] appearance] applyInvocationTo:self];
    return self;
}

- (void)configureCell:(ZIMShoppingLisItemCell *)cell {
    cell.firstTrigger = self.firstTrigger;
    cell.secondTrigger = self.secondTrigger;
    [cell setDefaultColor:self.defaultColor];
}

+ (instancetype)undoneCellConfigurator {
    return [ZIMListItemUndoneCellConfigurator new];
}

+ (instancetype)doneCellConfigurator {
    return [ZIMListItemDoneCellConfigurator new];
}

+ (instancetype)laterCellConfigurator {
    return [ZIMListItemLaterCellConfigurator new];
}

+ (id)appearance {
    return [MZAppearance appearanceForClass:[ZIMListItemCellConfigurator class]];
}

@end
