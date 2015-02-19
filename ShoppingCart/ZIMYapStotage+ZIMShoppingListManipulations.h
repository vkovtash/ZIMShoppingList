//
//  ZIMYapStotage+ZIMShoppingListManipulations.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage.h"
#import "ZIMStorageGoodsItem+ZIMYapRetrieving.h"
#import "ZIMStorageShoppingCartItem+ZIMYapRetrieving.h"

@interface ZIMYapStotage (ZIMShoppingListManipulations)
- (BOOL)isItemInList:(ZIMYapGoodsItem *)item;
- (void)appendGoodsItem:(ZIMYapGoodsItem *)item;
- (void)appendGoodsItems:(NSArray *)items;
- (void)moveItem:(ZIMYapListItem *)movedItem toIndex:(NSUInteger)index;
- (void)placeItem:(ZIMYapListItem *)movedItem beforeItem:(ZIMYapListItem *)indexItem;
- (void)placeItem:(ZIMYapListItem *)movedItem afterItem:(ZIMYapListItem *)indexItem;
- (void)removeItem:(ZIMYapListItem *)item;
- (void)removeAllItems;
- (void)setState:(ZIMCartItemState)state forItem:(ZIMYapListItem *)item;
@end
