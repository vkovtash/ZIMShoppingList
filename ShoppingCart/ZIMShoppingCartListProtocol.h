//
//  ZIMShoppingCartListProtocol.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListControllerProtocol.h"
#import "ZIMShoppingCartItem.h"

typedef NS_ENUM(NSUInteger, ZIMCartItemState) {
    ZIMCartItemStateUndone,
    ZIMCartItemStateDone,
    ZIMCartItemStateLater,
};

@protocol ZIMShoppingCartListProtocol <ZIMListControllerProtocol>
@property (readonly, nonatomic) ZIMCartItemState itemsStateFilter;

- (void)setItemsStateFilter:(ZIMCartItemState)itemsStateFilter;

- (BOOL)isItemsInList:(ZIMShoppingCartItem *)item;
- (void)appendItems:(NSArray *)items;
- (void)appendItem:(ZIMShoppingCartItem *)item;
- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)setState:(ZIMCartItemState)state forItemAtIndexPath:(NSIndexPath *)indexPath;
- (ZIMShoppingCartItem *)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
