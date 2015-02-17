//
//  ZIMYapStotage+ZIMTestData.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage+ZIMTestData.h"
#import "ZIMStorageGoodsItem+ZIMYapRetrieving.h"
#import "ZIMStorageCategory+ZIMYapRetrieving.h"

@implementation ZIMYapStotage (ZIMTestData)

- (void)fillWithTestData {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageGoodsItem *goodsItem = nil;
        ZIMStorageCategory *category = nil;
        NSString *categoryKey = nil, *goodsItemKey = nil;
        
        for (NSInteger categoryIndex = 0; categoryIndex < 10; categoryIndex++) {
            categoryKey = [NSString stringWithFormat:@"Category %ld", (long)categoryIndex];
            category = [ZIMStorageCategory new];
            category.categoryKey = categoryKey;
            category.title = categoryKey;
            
            [transaction setObject:category forKey:category.categoryKey inCollection:category.collection];
            
            for (NSInteger goodsItemIndex = 0; goodsItemIndex < 10; goodsItemIndex ++) {
                goodsItemKey = [NSString stringWithFormat:@"Item %ld %ld", (long)categoryIndex, (long)goodsItemIndex];
                goodsItem = [ZIMStorageGoodsItem new];
                goodsItem.categoryKey = categoryKey;
                goodsItem.itemKey = goodsItemKey;
                goodsItem.title = goodsItemKey;
                
                [transaction setObject:goodsItem forKey:goodsItem.itemKey inCollection:goodsItem.collection];
            }
        }
    }];
}

@end
