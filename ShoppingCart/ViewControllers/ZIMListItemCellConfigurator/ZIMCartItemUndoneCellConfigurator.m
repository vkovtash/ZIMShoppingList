//
//  ZIMCartItemUndoneCellConfigurator.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMCartItemUndoneCellConfigurator.h"

@implementation ZIMCartItemUndoneCellConfigurator

- (void)configureCell:(ZIMShoppingLisItemCell *)cell {
    [super configureCell:cell];
    
    __weak __typeof(&*self) weakSelf = self;
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.doneImage]
                            color:self.doneColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setDoneAtcionTriggeredForCell:cell];
     }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.deleteImage]
                            color:self.deleteColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState2
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate deleteAtcionTriggeredForCell:cell];
     }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.laterImage]
                            color:self.laterColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setLaterAtcionTriggeredForCell:cell];
     }];
}

@end
