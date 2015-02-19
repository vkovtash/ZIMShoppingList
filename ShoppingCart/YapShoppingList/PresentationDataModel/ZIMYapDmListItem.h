//
//  ZIMYapDmListItem.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMDMListItem.h"
#import "ZIMYapGoodsItem.h"
#import "ZIMYapListCategory.h"

@interface ZIMYapDmListItem : ZIMDMListItem
@property (readonly, nonatomic) ZIMYapGoodsItem *storageGoodsItem;
@property (readonly, nonatomic) ZIMYapListCategory *storageCategory;

- (instancetype)init __attribute__((unavailable("Should be created with initWithGoodsItem:")));
- (instancetype)initWithGoodsItem:(ZIMYapGoodsItem *)goodsItem category:(ZIMYapListCategory *)category;
@end
