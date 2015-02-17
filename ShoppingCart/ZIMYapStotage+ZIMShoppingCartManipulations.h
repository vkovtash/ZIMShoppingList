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
- (void)appendGoodsItem:(ZIMStorageGoodsItem *)item;
- (void)appendGoodsItems:(NSArray *)items;
- (void)placeItem:(ZIMStorageShoppingCartItem *)movedItem beforeItem:(ZIMStorageShoppingCartItem *)indexItem;
- (void)removeItem:(ZIMStorageShoppingCartItem *)item;
@end
