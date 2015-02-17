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

@interface ZIMYapShoppingCartListController()
@property (strong, nonatomic) YapDatabaseConnection *connection;
@property (strong, nonatomic) YapDatabaseViewMappings *mappings;
@end

@implementation ZIMYapShoppingCartListController
@synthesize delegate = _delegate;

- (instancetype)initWithStorage:(ZIMYapStotage *)storage {
    self = [super init];
    if (self) {
        _storage = storage;
        
        _connection = [_storage.database newConnection];
        
        _mappings = [[YapDatabaseViewMappings alloc] initWithGroups:@[[ZIMStorageShoppingCartItem collection]] view:ZIMYapShoppingCartViewName];
        
        [_connection beginLongLivedReadTransaction];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storageModifiedNotification:)
                                                     name:YapDatabaseModifiedNotification
                                                   object:_storage.database];
        
        
        [_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [_mappings updateWithTransaction:transaction];
        }];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - YapDatabase notifications

- (void)storageModifiedNotification:(NSNotification *)note {
    NSArray *notifications = [self.connection beginLongLivedReadTransaction];
    
    if (notifications.count == 0) {
        return;
    }
    
    NSArray *sectionChanges = nil;
    NSArray *rowChanges = nil;
    
    [[self.connection ext:self.mappings.view] getSectionChanges:&sectionChanges
                                                     rowChanges:&rowChanges
                                               forNotifications:notifications
                                                   withMappings:self.mappings];
    
    if ([sectionChanges count] == 0 & [rowChanges count] == 0) { // Nothing has changed that affects our tableView
        return;
    }
    
    NSMutableArray *changes = [NSMutableArray arrayWithCapacity:rowChanges.count];
    ZIMListDataChange *newChange = nil;
    
    for (YapDatabaseViewRowChange *change in rowChanges) {
        if (!(change.changes & YapDatabaseViewChangedObject)) {
            continue;
        }
        
        switch (change.type) {
            case YapDatabaseViewChangeInsert:
                newChange = [ZIMListDataChange newInsertWithObject:[self objectAtIndexPath:change.newIndexPath]
                                                       atIndexPath:change.newIndexPath];
                break;
                
            case YapDatabaseViewChangeDelete:
                newChange = [ZIMListDataChange newDeleteAIndexPath:change.indexPath];
                break;
                
            case YapDatabaseViewChangeMove:
                newChange = [ZIMListDataChange newMoveWithObject:[self objectAtIndexPath:change.newIndexPath]
                                                     toIndexPath:change.newIndexPath
                                                   fromIndexPath:change.indexPath];
                break;
                
            case YapDatabaseViewChangeUpdate:
                newChange = [ZIMListDataChange newUpdateWithObject:[self objectAtIndexPath:change.indexPath]
                                                       atIndexPath:change.indexPath];
                break;
        }
        
        [changes addObject:newChange];
    }
    
    [self.delegate listDataChangedWithChanges:changes];
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

- (void)appendItems:(NSArray *)items {
    NSArray *goodsItems = [items valueForKeyPath:@"storageGoodsItem"];
    [self.storage appendGoodsItems:goodsItems];
}

- (void)appendItem:(ZIMYapShoppingCartItem *)item {
    [self.storage appendGoodsItem:item.storageGoodsItem];
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    __block ZIMStorageShoppingCartItem *movedItem = nil;
    __block ZIMStorageShoppingCartItem *indexItem = nil;
    
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        movedItem = [[transaction ext:self.mappings.view] objectAtIndexPath:fromIndexPath withMappings:self.mappings];
        indexItem = [[transaction ext:self.mappings.view] objectAtIndexPath:toIndexPath withMappings:self.mappings];
    }];
    
    [self.storage placeItem:movedItem beforeItem:indexItem];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMStorageShoppingCartItem *item = nil;
    
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
        item = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
    }];
    
    [self.storage removeItem:item];
}

- (void)setStateForItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
