//
//  ZIMYapShoppingCartItem.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapShoppingCartItem.h"
#import "ZIMYapShoppingCartCategory.h"

@implementation ZIMYapShoppingCartItem
@synthesize category = _category;

- (instancetype)initWithGoodsItem:(ZIMStorageGoodsItem *)goodsItem category:(ZIMStorageCategory *)category {
    self = [super init];
    if (self) {
        _storageGoodsItem = goodsItem;
        _storageCategory = category;
        _category = [[ZIMYapShoppingCartCategory alloc] initWithCategory:category];
    }
    return self;
}

- (NSString *)title {
    return self.storageGoodsItem.title;
}

- (NSString *)itemId {
    return self.storageGoodsItem.itemKey;
}

@end
