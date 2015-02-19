//
//  ZIMYapStotage+ZIMShoppingListManipulations.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage+ZIMShoppingListManipulations.h"
#import <YapDatabase/YapDatabaseView.h>

static const long ZIMBasicYapStotageSortOrderStep = 65635;

@implementation ZIMYapStotage (ZIMShoppingListManipulations)

- (BOOL)isItemInList:(ZIMYapGoodsItem *)item {
    __block BOOL isItemInList = NO;
    [self.bgConnection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        isItemInList = [ZIMYapListItem entityExistsForKey:item.itemKey inTransaction:transaction];
    }];
    return isItemInList;
}

- (void)appendGoodsItems:(NSArray *)items {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (ZIMYapGoodsItem *goodsItem in [items reverseObjectEnumerator]) {
            if ([ZIMYapListItem entityExistsForKey:goodsItem.itemKey inTransaction:transaction]) {
                continue; //Already in the list
            }
            
            ZIMYapListItem *currentTopItem = nil;
            currentTopItem = [[transaction ext:ZIMYapShoppingCartViewName] firstObjectInGroup:[ZIMYapListItem collection]];
            long maxSortOrder = currentTopItem.sortOrder;
            
            ZIMYapListItem *newCartItem = [ZIMYapListItem new];
            newCartItem.storageKey = goodsItem.itemKey;
            newCartItem.sortOrder = maxSortOrder + ZIMBasicYapStotageSortOrderStep;
            
            [newCartItem saveInTransaction:transaction];
        }
    }];
}

- (void)appendGoodsItem:(ZIMYapGoodsItem *)item {
    [self appendGoodsItems:@[item]];
}

- (void)moveItem:(ZIMYapListItem *)movedItem toIndex:(NSUInteger)index {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMYapListItem *localMovedItem = [ZIMYapListItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = [ZIMYapListItem collection];
        
        ZIMYapListItem *currentItem = [viewTransaction objectAtIndex:index inGroup:group];
        
        if (index == 0) {
            localMovedItem.sortOrder = currentItem.sortOrder + ZIMBasicYapStotageSortOrderStep;
        }
        else {
            ZIMYapListItem *topItem = [viewTransaction objectAtIndex:index - 1  inGroup:group];
            localMovedItem.sortOrder = currentItem.sortOrder + (topItem.sortOrder - currentItem.sortOrder) / 2;
        }
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)placeItem:(ZIMYapListItem *)movedItem beforeItem:(ZIMYapListItem *)indexItem {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMYapListItem *localMovedItem = [ZIMYapListItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        ZIMYapListItem *currentItem = [ZIMYapListItem entityWithKey:indexItem.storageKey
                                                                              inTransaction:transaction];
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = nil;
        NSUInteger index = 0;
        
        BOOL result = [viewTransaction getGroup:&group
                                          index:&index
                                         forKey:indexItem.storageKey
                                   inCollection:[ZIMYapListItem collection]];
        if (!result) {
            return;
        }
        
        if (index == 0) {
            localMovedItem.sortOrder = currentItem.sortOrder + ZIMBasicYapStotageSortOrderStep;
        }
        else {
            ZIMYapListItem *topItem = [viewTransaction objectAtIndex:index - 1  inGroup:group];
            localMovedItem.sortOrder = currentItem.sortOrder + (topItem.sortOrder - currentItem.sortOrder) / 2;
        }
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)placeItem:(ZIMYapListItem *)movedItem afterItem:(ZIMYapListItem *)indexItem {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMYapListItem *localMovedItem = [ZIMYapListItem entityWithKey:movedItem.storageKey
                                                                                 inTransaction:transaction];
        if (!localMovedItem) {
            return;
        }
        
        ZIMYapListItem *currentItem = [ZIMYapListItem entityWithKey:indexItem.storageKey
                                                                              inTransaction:transaction];
        
        YapDatabaseViewTransaction *viewTransaction = [transaction ext:ZIMYapShoppingCartViewName];
        NSString *group = nil;
        NSUInteger index = 0;
        
        BOOL result = [viewTransaction getGroup:&group
                                          index:&index
                                         forKey:indexItem.storageKey
                                   inCollection:[ZIMYapListItem collection]];
        if (!result) {
            return;
        }
        
        ZIMYapListItem *baseItem = [viewTransaction objectAtIndex:index + 1  inGroup:group];
        localMovedItem.sortOrder = baseItem.sortOrder + (currentItem.sortOrder - baseItem.sortOrder) / 2;
        
        [localMovedItem saveInTransaction:transaction];
    }];
}

- (void)removeItem:(ZIMYapListItem *)item {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [item removeInTransaction:transaction];
    }];
}

- (void)removeAllItems {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:[ZIMYapListItem collection]];
    }];
}

- (void)setState:(ZIMCartItemState)state forItem:(ZIMYapListItem *)item {
    [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        ZIMYapListItem *localItem = [ZIMYapListItem entityWithKey:item.storageKey inTransaction:transaction];
        if (localItem.state == state) {
            return;
        }
        localItem.state = state;
        [localItem saveInTransaction:transaction];
    }];
}

@end
