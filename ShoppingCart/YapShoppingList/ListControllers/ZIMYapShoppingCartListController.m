//
//  ZIMYapShoppingCartListController.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapShoppingCartListController.h"
#import <UIKit/UITableView.h>
#import "ZIMYapDmListItem.h"
#import "ZIMYapStotage+ZIMShoppingListManipulations.h"

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

- (void)setItemsStateFilter:(ZIMListItemState)itemsStateFilter {
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
                                                           view:ZIMYapShoppingListByStateViewName];
    
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

- (NSInteger)numberOfAllItemsInList {
    __block NSUInteger numberOfItems = 0;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        numberOfItems = [[transaction ext:ZIMYapShoppingListByStateViewName] numberOfItemsInAllGroups];
    }];
    return numberOfItems;
}

- (NSInteger)numberOfSections {
    return [self.mappings numberOfSections];
}

- (NSInteger)numberofItemsInSection:(NSInteger)section {
    return [self.mappings numberOfItemsInSection:section];
}

- (ZIMDMListItem *)objectAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMDMListItem *result = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMYapListItem *cartItem = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
        ZIMYapGoodsItem *goodsItem = [ZIMYapGoodsItem entityWithKey:cartItem.storageKey inTransaction:transaction];
        ZIMYapListCategory *category = [ZIMYapListCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        result = [[ZIMYapDmListItem alloc] initWithGoodsItem:goodsItem category:category];
    }];
    return result;
}

- (id)objectForSection:(NSInteger)section {
    return nil;
}

- (BOOL)isItemInList:(ZIMYapDmListItem *)item {
    return [self.storage isItemInList:item.storageGoodsItem];
}

- (void)appendItems:(NSArray *)items {
    NSArray *goodsItems = [items valueForKeyPath:@"storageGoodsItem"];
    [self.storage appendGoodsItems:goodsItems];
}

- (void)appendItem:(ZIMYapDmListItem *)item {
    [self.storage appendGoodsItem:item.storageGoodsItem];
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.row == toIndexPath.row) {
        return;
    }
    
    __block ZIMYapListItem *movedItem = nil, *indexItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        indexItem = [[transaction ext:self.mappings.view] objectAtIndexPath:toIndexPath withMappings:self.mappings];
        movedItem = [[transaction ext:self.mappings.view] objectAtIndexPath:fromIndexPath withMappings:self.mappings];
    }];
    
    if (fromIndexPath.row < toIndexPath.row) {
        [self.storage placeItem:movedItem afterItem:indexItem];
    }
    else if (fromIndexPath.row > toIndexPath.row) {
        [self.storage placeItem:movedItem beforeItem:indexItem];
    }
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMYapListItem *item = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        item = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    [self.storage removeItem:item];
}

- (void)removeAllItems {
    [self.storage removeAllItems];
}

- (void)setState:(ZIMListItemState)state forItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMYapListItem *item = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        item = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    [self.storage setState:state forItem:item];
    [self.storage moveItem:item toIndex:0];
}

@end
