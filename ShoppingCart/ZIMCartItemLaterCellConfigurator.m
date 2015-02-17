//
//  ZIMCartItemLaterCellConfigurator.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMCartItemLaterCellConfigurator.h"

@implementation ZIMCartItemLaterCellConfigurator

- (void)configureCell:(ZIMCartItemTableViewCell *)cell {
    [super configureCell:cell];
    
    __weak __typeof(&*self) weakSelf = self;
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.undoneImage]
                            color:self.undoneColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setUndoneDoneAtcionTriggeredForCell:cell];
     }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.doneImage]
                            color:self.doneColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState2
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setDoneAtcionTriggeredForCell:cell];
     }];
}

@end
