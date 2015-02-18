//
//  ZIMYapStotage+ZIMShoppingCartManipulations.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage.h"
#import "ZIMStorageGoodsItem+ZIMYapRetrieving.h"
#import "ZIMStorageShoppingCartItem+ZIMYapRetrieving.h"

@interface ZIMYapStotage (ZIMShoppingCartManipulations)
- (BOOL)isItemInList:(ZIMStorageGoodsItem *)item;
- (void)appendGoodsItem:(ZIMStorageGoodsItem *)item;
- (void)appendGoodsItems:(NSArray *)items;
- (void)moveItem:(ZIMStorageShoppingCartItem *)movedItem toIndex:(NSUInteger)index;
- (void)removeItem:(ZIMStorageShoppingCartItem *)item;
- (void)removeAllItems;
- (void)setState:(ZIMCartItemState)state forItem:(ZIMStorageShoppingCartItem *)item;
@end
