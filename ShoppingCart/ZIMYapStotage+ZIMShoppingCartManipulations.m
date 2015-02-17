//
//  ZIMYapStotage+ZIMShoppingCartManipulations.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage+ZIMShoppingCartManipulations.h"
#import <YapDatabase/YapDatabaseView.h>

static const long ZIMBasicYapStotageSortOrderStep = 65635;

@implementation ZIMYapStotage (ZIMShoppingCartManipulations)

- (void)appendGoodsItems:(NSArray *)items {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (ZIMStorageGoodsItem *goodsItem in items) {
            if ([ZIMStorageShoppingCartItem entityExistsForKey:goodsItem.itemKey inTransaction:transaction]) {
                continue; //Already in the list
            }
            
            ZIMStorageShoppingCartItem *currentTopItem = nil;
            currentTopItem = [[transaction ext:ZIMYapShoppingCartViewName] firstObjectInGroup:[ZIMStorageShoppingCartItem collection]];
            long maxSortOrder = currentTopItem.sortOrder;
            
            ZIMStorageShoppingCartItem *newCartItem = [ZIMStorageShoppingCartItem new];
            newCartItem.storageKey = goodsItem.itemKey;
            newCartItem.sortOrder = maxSortOrder + ZIMBasicYapStotageSortOrderStep;
            
            [newCartItem saveInTransaction:transaction];
        }
    }];
}

- (void)appendGoodsItem:(ZIMStorageGoodsItem *)item {
    [self appendGoodsItems:@[item]];
}

- (void)placeItem:(ZIMStorageShoppingCartItem *)movedItem beforeItem:(ZIMStorageShoppingCartItem *)indexItem {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageShoppingCartItem *localMovedItem = nil, *localIndexItem = nil;
        localMovedItem = [ZIMStorageShoppingCartItem entityWithKey:movedItem.storageKey inTransaction:transaction];
        localIndexItem = [ZIMStorageShoppingCartItem entityWithKey:indexItem.storageKey inTransaction:transaction];
        localMovedItem.sortOrder = localIndexItem.sortOrder + 1;
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)removeItem:(ZIMStorageShoppingCartItem *)item {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [item removeInTransaction:transaction];
    }];
}

- (void)setState:(ZIMCartItemState)state forItem:(ZIMStorageShoppingCartItem *)item {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageShoppingCartItem *localItem = [ZIMStorageShoppingCartItem entityWithKey:item.storageKey inTransaction:transaction];
        if (localItem.state == state) {
            return;
        }
        localItem.state = state;
        [localItem saveInTransaction:transaction];
    }];
}

@end
