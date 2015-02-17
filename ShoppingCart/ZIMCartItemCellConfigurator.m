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
    self.defaultColor = [UIColor colorWithWhite:0.9 alpha:1.];
    self.undoneColor = [UIColor colorWithRed:0.3 green:0.3 blue:1. alpha:1.];
    self.doneColor = [UIColor colorWithRed:.7 green:0.1 blue:0.7 alpha:1.];
    self.laterColor = [UIColor colorWithRed:0.3 green:1. blue:1. alpha:1.];
    self.deleteColor = [UIColor colorWithRed:1. green:0.3 blue:0.3 alpha:1.];
    self.undoneImage = [UIImage imageNamed:@"list"];
    self.doneImage = [UIImage imageNamed:@"check"];
    self.laterImage = [UIImage imageNamed:@"clock"];
    self.deleteImage = [UIImage imageNamed:@"cross"];
    
    return self;
}

- (void)configureCell:(ZIMCartItemTableViewCell *)cell {
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

@end
