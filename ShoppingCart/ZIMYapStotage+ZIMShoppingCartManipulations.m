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

- (BOOL)isItemInList:(ZIMStorageGoodsItem *)item {
    __block BOOL isItemInList = NO;
    [self.bgConnection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        isItemInList = [ZIMStorageShoppingCartItem entityExistsForKey:item.itemKey inTransaction:transaction];
    }];
    return isItemInList;
}

- (void)appendGoodsItems:(NSArray *)items {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (ZIMStorageGoodsItem *goodsItem in [items reverseObjectEnumerator]) {
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

- (void)moveItem:(ZIMStorageShoppingCartItem *)movedItem toIndex:(NSUInteger)index {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageShoppingCartItem *localMovedItem = [ZIMStorageShoppingCartItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = [ZIMStorageShoppingCartItem collection];
        
        ZIMStorageShoppingCartItem *currentItem = [viewTransaction objectAtIndex:index inGroup:group];
        
        if (index == 0) {
            localMovedItem.sortOrder = currentItem.sortOrder + ZIMBasicYapStotageSortOrderStep;
        }
        else {
            ZIMStorageShoppingCartItem *topItem = [viewTransaction objectAtIndex:index - 1  inGroup:group];
            localMovedItem.sortOrder = currentItem.sortOrder + (topItem.sortOrder - currentItem.sortOrder) / 2;
        }
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)placeItem:(ZIMStorageShoppingCartItem *)movedItem beforeItem:(ZIMStorageShoppingCartItem *)indexItem {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageShoppingCartItem *localMovedItem = [ZIMStorageShoppingCartItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        ZIMStorageShoppingCartItem *currentItem = [ZIMStorageShoppingCartItem entityWithKey:indexItem.storageKey
                                                                              inTransaction:transaction];
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = nil;
        NSUInteger index = 0;
        
        BOOL result = [viewTransaction getGroup:&group
                                          index:&index
                                         forKey:indexItem.storageKey
                                   inCollection:[ZIMStorageShoppingCartItem collection]];
        if (!result) {
            return;
        }
        
        if (index == 0) {
            localMovedItem.sortOrder = currentItem.sortOrder + ZIMBasicYapStotageSortOrderStep;
        }
        else {
            ZIMStorageShoppingCartItem *topItem = [viewTransaction objectAtIndex:index - 1  inGroup:group];
            localMovedItem.sortOrder = currentItem.sortOrder + (topItem.sortOrder - currentItem.sortOrder) / 2;
        }
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)placeItem:(ZIMStorageShoppingCartItem *)movedItem afterItem:(ZIMStorageShoppingCartItem *)indexItem {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMStorageShoppingCartItem *localMovedItem = [ZIMStorageShoppingCartItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        ZIMStorageShoppingCartItem *currentItem = [ZIMStorageShoppingCartItem entityWithKey:indexItem.storageKey
                                                                              inTransaction:transaction];
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = nil;
        NSUInteger index = 0;
        
        BOOL result = [viewTransaction getGroup:&group
                                          index:&index
                                         forKey:indexItem.storageKey
                                   inCollection:[ZIMStorageShoppingCartItem collection]];
        if (!result) {
            return;
        }
        
        ZIMStorageShoppingCartItem *baseItem = [viewTransaction objectAtIndex:index + 1  inGroup:group];
        localMovedItem.sortOrder = baseItem.sortOrder + (currentItem.sortOrder - baseItem.sortOrder) / 2;
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)removeItem:(ZIMStorageShoppingCartItem *)item {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [item removeInTransaction:transaction];
    }];
}

- (void)removeAllItems {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:[ZIMStorageShoppingCartItem collection]];
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
