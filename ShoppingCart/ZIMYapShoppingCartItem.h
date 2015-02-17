//
//  ZIMYapShoppingCartItem.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMShoppingCartItem.h"
#import "ZIMStorageGoodsItem.h"
#import "ZIMStorageCategory.h"

@interface ZIMYapShoppingCartItem : ZIMShoppingCartItem
@property (readonly, nonatomic) ZIMStorageGoodsItem *storageGoodsItem;
@property (readonly, nonatomic) ZIMStorageCategory *storageCategory;

- (instancetype)init __attribute__((unavailable("Should be created with initWithGoodsItem:")));
- (instancetype)initWithGoodsItem:(ZIMStorageGoodsItem *)goodsItem category:(ZIMStorageCategory *)category;
@end
