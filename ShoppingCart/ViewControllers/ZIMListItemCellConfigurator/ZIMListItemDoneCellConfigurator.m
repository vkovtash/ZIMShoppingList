//
//  ZIMListItemDoneCellConfigurator.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMListItemDoneCellConfigurator.h"

@implementation ZIMListItemDoneCellConfigurator

- (void)configureCell:(ZIMShoppingLisItemCell *)cell {
    [super configureCell:cell];
    
    __weak __typeof(&*self) weakSelf = self;
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.undoneImage]
                            color:self.mainColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setUndoneDoneAtcionTriggeredForCell:cell];
     }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.laterImage]
                            color:self.laterColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState4
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate setLaterAtcionTriggeredForCell:cell];
     }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:self.deleteImage]
                            color:self.deleteColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(id cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         __strong __typeof(&*weakSelf) strongSelf = weakSelf;
         [strongSelf.delegate deleteAtcionTriggeredForCell:cell];
     }];
}

@end
