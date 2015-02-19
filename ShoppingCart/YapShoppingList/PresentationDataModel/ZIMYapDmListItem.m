//
//  ZIMYapDmListItem.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapDmListItem.h"
#import "ZIMYapDmListCategory.h"

@implementation ZIMYapDmListItem
@synthesize category = _category;

- (instancetype)initWithGoodsItem:(ZIMYapGoodsItem *)goodsItem category:(ZIMYapListCategory *)category {
    self = [super init];
    if (self) {
        _storageGoodsItem = goodsItem;
        _storageCategory = category;
        _category = [[ZIMYapDmListCategory alloc] initWithCategory:category];
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
