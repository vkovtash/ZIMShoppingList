//
//  ZIMYapShoppingCartListController.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapShoppingCartListController.h"
#import <UIKit/UITableView.h>
#import <YapDatabase/YapDatabaseView.h>
#import "ZIMYapShoppingCartItem.h"
#import "ZIMStorageShoppingCartItem.h"
#import "ZIMStorageCategory+ZIMYapRetrieving.h"
#import "ZIMYapStotage+ZIMShoppingCartManipulations.h"
#import "YapDatabaseViewConnection+ZIMGetChanges.h"

@interface ZIMYapShoppingCartListController()
@property (strong, nonatomic) YapDatabaseConnection *connection;
@property (strong, nonatomic) YapDatabaseViewMappings *mappings;
@end

@implementation ZIMYapShoppingCartListController
@synthesize itemsStateFilter = _itemsStateFilter;
@synthesize delegate = _delegate;

- (instancetype)initWithStorage:(ZIMYapStotage *)storage {
    self = [super init];
    if (self) {
        _storage = storage;
        _connection = [_storage.database newConnection];
        [self applyStateFilter];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setItemsStateFilter:(ZIMCartItemState)itemsStateFilter {
    if (_itemsStateFilter != itemsStateFilter) {
        _itemsStateFilter = itemsStateFilter;
        [self applyStateFilter];
    }
}

- (void)applyStateFilter {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:YapDatabaseModifiedNotification
                                                  object:self.storage.database];
    
    NSString *stateStingRepresentation = [NSString stringWithFormat:@"%ld", self.itemsStateFilter];
    
    self.mappings = [[YapDatabaseViewMappings alloc] initWithGroups:@[stateStingRepresentation]
                                                           view:ZIMYapShoppingCartByStateViewName];
    
    [self.connection beginLongLivedReadTransaction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storageModifiedNotification:)
                                                 name:YapDatabaseModifiedNotification
                                               object:self.storage.database];
    
    
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        [self.mappings updateWithTransaction:transaction];
    }];
    
    [self.delegate listControllerDidReloadData:self];
}

#pragma mark - YapDatabase notifications

- (void)storageModifiedNotification:(NSNotification *)note {
    NSArray *notifications = [self.connection beginLongLivedReadTransaction];
    
    NSArray *sectionChanges = nil, *rowChanges = nil;
    [[self.connection ext:self.mappings.view] zim_getSectionChanges:&sectionChanges
                                                         rowChanges:&rowChanges
                                                   forNotifications:notifications
                                                       withMappings:self.mappings];
    
    if (sectionChanges.count == 0 & rowChanges.count == 0) { // Nothing has changed that affects our tableView
        return;
    }
    
    [self.delegate listController:self didChangeWithRowChanges:rowChanges sectionChanges:sectionChanges];
}

#pragma mark - ZIMShoppingCartListProtocol

- (NSInteger)numberOfSections {
    return [self.mappings numberOfSections];
}

- (NSInteger)numberofItemsInSection:(NSInteger)section {
    return [self.mappings numberOfItemsInSection:section];
}

- (ZIMShoppingCartItem *)objectAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMShoppingCartItem *result = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMStorageShoppingCartItem *cartItem = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
        ZIMStorageGoodsItem *goodsItem = [ZIMStorageGoodsItem entityWithKey:cartItem.storageKey inTransaction:transaction];
        ZIMStorageCategory *category = [ZIMStorageCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        result = [[ZIMYapShoppingCartItem alloc] initWithGoodsItem:goodsItem category:category];
    }];
    return result;
}

- (id)objectForSection:(NSInteger)section {
    return nil;
}

- (BOOL)isItemsInList:(ZIMYapShoppingCartItem *)item {
    return [self.storage isItemInList:item.storageGoodsItem];
}

- (void)appendItems:(NSArray *)items {
    NSArray *goodsItems = [items valueForKeyPath:@"storageGoodsItem"];
    [self.storage appendGoodsItems:goodsItems];
}

- (void)appendItem:(ZIMYapShoppingCartItem *)item {
    [self.storage appendGoodsItem:item.storageGoodsItem];
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.row == toIndexPath.row) {
        return;
    }
    
    __block ZIMStorageShoppingCartItem *movedItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        movedItem = [[transaction ext:self.mappings.view] objectAtIndexPath:fromIndexPath withMappings:self.mappings];
    }];
    
    if (fromIndexPath.row < toIndexPath.row) {
        [self.storage moveItem:movedItem toIndex:toIndexPath.row + 1];
    }
    else if (fromIndexPath.row > toIndexPath.row) {
        [self.storage moveItem:movedItem toIndex:toIndexPath.row];
    }
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMStorageShoppingCartItem *item = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        item = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    [self.storage removeItem:item];
}

- (void)setState:(ZIMCartItemState)state forItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMStorageShoppingCartItem *item = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        item = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    [self.storage setState:state forItem:item];
}

@end
