//
//  ZIMYapGoodsCatalogListController.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapGoodsCatalogListController.h"
#import <YapDatabase/YapDatabaseView.h>
#import "ZIMStorageCategory+ZIMYapRetrieving.h"
#import "ZIMYapShoppingCartItem.h"
#import "ZIMYapShoppingCartCategory.h"

@interface ZIMYapGoodsCatalogListController()
@property (strong, nonatomic) YapDatabaseViewMappings *mappings;
@property (strong, nonatomic) YapDatabaseConnection *connection;
@end

@implementation ZIMYapGoodsCatalogListController
@synthesize delegate = _delegate;

- (instancetype)initWithStorage:(ZIMYapStotage *)storage {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _storage = storage;
    _connection = [storage.database newConnection];
    
    YapDatabaseViewMappingGroupFilter groupFilterBlock = ^BOOL(NSString *group, YapDatabaseReadTransaction *transaction){
        return YES;
    };
    
    YapDatabaseViewMappingGroupSort groupSortingBlock = ^NSComparisonResult(NSString *group1, NSString *group2, YapDatabaseReadTransaction *transaction){
        ZIMStorageCategory *category1 = [ZIMStorageCategory entityWithKey:group1 inTransaction:transaction];
        ZIMStorageCategory *category2 = [ZIMStorageCategory entityWithKey:group2 inTransaction:transaction];
        return [category1.title caseInsensitiveCompare:category2.title];
    };
    
    _mappings = [[YapDatabaseViewMappings alloc] initWithGroupFilterBlock:groupFilterBlock sortBlock:groupSortingBlock view:ZIMYapGoodsViewName];
    
    [_connection beginLongLivedReadTransaction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storageModifiedNotification:)
                                                 name:YapDatabaseModifiedNotification
                                               object:_storage.database];
    
    
    [_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        [_mappings updateWithTransaction:transaction];
    }];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - YapDatabase notifications

- (void)storageModifiedNotification:(NSNotification *)note {
    [self.connection beginLongLivedReadTransaction];
}

#pragma mark - ZIMListProtocol

- (NSInteger)numberOfSections {
    return [self.mappings numberOfSections];
}

- (NSInteger)numberofItemsInSection:(NSInteger)section {
    return [self.mappings numberOfItemsInSection:section];
}

- (id)objectForSection:(NSInteger)section {
    __block ZIMYapShoppingCartCategory *resultItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMStorageGoodsItem *goodsItem = [[transaction ext:self.mappings.view] objectAtRow:0 inSection:section withMappings:self.mappings];
        ZIMStorageCategory *category = [ZIMStorageCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        resultItem = [[ZIMYapShoppingCartCategory alloc] initWithCategory:category];
    }];
    return resultItem;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMYapShoppingCartItem *resultItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMStorageGoodsItem *goodsItem = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
        ZIMStorageCategory *category = [ZIMStorageCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        
        resultItem = [[ZIMYapShoppingCartItem alloc] initWithGoodsItem:goodsItem category:category];
    }];
    return resultItem;
}

@end
