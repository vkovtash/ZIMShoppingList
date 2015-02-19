//
//  ZIMCartItemCellConfigurator.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMCartItemCellConfigurator.h"
#import "ZIMCartItemUndoneCellConfigurator.h"
#import "ZIMCartItemDoneCellConfigurator.h"
#import "ZIMCartItemLaterCellConfigurator.h"

@implementation ZIMCartItemCellConfigurator

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
    return [ZIMCartItemUndoneCellConfigurator new];
}

+ (instancetype)doneCellConfigurator {
    return [ZIMCartItemDoneCellConfigurator new];
}

+ (instancetype)laterCellConfigurator {
    return [ZIMCartItemLaterCellConfigurator new];
}

+ (id)appearance {
    return [MZAppearance appearanceForClass:[ZIMCartItemCellConfigurator class]];
}

@end
