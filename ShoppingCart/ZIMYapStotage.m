//
//  ZIMYapStotage.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage.h"
#import <YapDatabase/YapDatabaseView.h>
#import "ZIMStorageCategory+ZIMYapRetrieving.h"
#import "ZIMStorageGoodsItem+ZIMYapRetrieving.h"
#import "ZIMStorageShoppingCartItem+ZIMYapRetrieving.h"


NSString *const ZIMYapGategoriesViewName = @"ZIMYapGategoriesViewName";
NSString *const ZIMYapGoodsViewName = @"ZIMYapGoodsViewName";
NSString *const ZIMYapShoppingCartViewName = @"ZIMYapShoppingCartViewName";

@implementation ZIMYapStotage

- (instancetype)initWithDatabaseName:(NSString *)datanaseName {
    self = [super init];
    if (self) {
        _databaseName = datanaseName;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        _databasePath = [baseDir stringByAppendingPathComponent:_databaseName];
        
        [self configureDatabase];
        [self fillWithTestData];
    }
    return self;
}

- (void) configureDatabase {
    _database = [[YapDatabase alloc] initWithPath:_databasePath];
    _bgConnection = [_database newConnection];
    
    YapDatabaseViewGroupingWithObjectBlock categoriesGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMStorageCategory *object) {
        return [object isKindOfClass:[ZIMStorageCategory class]] ? collection : nil;
    };
    
    YapDatabaseViewSortingWithObjectBlock categoriesSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMStorageCategory *object1, NSString *collection2, NSString *key2, ZIMStorageCategory *object2) {
        return [object1.title caseInsensitiveCompare:object2.title];
    };
    
    YapDatabaseView *categoriesView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:categoriesGroupingBlock]
                                                                        sorting:[YapDatabaseViewSorting withObjectBlock:categoriesSortingBlock]
                                                                     versionTag:@"1.1"];
    
    NSSet *categoriesCollections = [NSSet setWithObject:[ZIMStorageCategory collection]];
    [categoriesView.options setAllowedCollections:[[YapWhitelistBlacklist alloc] initWithWhitelist:categoriesCollections]];
    [_database registerExtension:categoriesView withName:ZIMYapGategoriesViewName];
    
    YapDatabaseViewGroupingWithObjectBlock goodsGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMStorageGoodsItem *object) {
        if ([object isKindOfClass:[ZIMStorageGoodsItem class]]) {
            return object.categoryKey;
        }
        return nil;
    };
    
    YapDatabaseViewSortingWithObjectBlock goodsSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMStorageGoodsItem *object1, NSString *collection2, NSString *key2, ZIMStorageGoodsItem *object2) {
        return [object1.title caseInsensitiveCompare:object2.title];
    };
    
    YapDatabaseView *goodsView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:goodsGroupingBlock]
                                                                   sorting:[YapDatabaseViewSorting withObjectBlock:goodsSortingBlock]
                                                                versionTag:@"1.1"];
    
    NSSet *goodsCollections = [NSSet setWithObject:[ZIMStorageGoodsItem collection]];
    [goodsView.options setAllowedCollections:[[YapWhitelistBlacklist alloc] initWithWhitelist:goodsCollections]];
    [_database registerExtension:goodsView withName:ZIMYapGoodsViewName];
    
    YapDatabaseViewGroupingWithObjectBlock cartGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMStorageGoodsItem *object) {
        if ([object isKindOfClass:[ZIMStorageShoppingCartItem class]]) {
            return collection;
        }
        return nil;
    };
    
    YapDatabaseViewSortingWithObjectBlock cartSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMStorageShoppingCartItem *object1, NSString *collection2, NSString *key2, ZIMStorageShoppingCartItem *object2) {
        if (object1.sortOrder > object2.sortOrder) {
            return NSOrderedAscending;
        }
        else if (object1.sortOrder < object2.sortOrder) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    };
    
    YapDatabaseView *cartView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:cartGroupingBlock]
                                                                  sorting:[YapDatabaseViewSorting withObjectBlock:cartSortingBlock]
                                                               versionTag:@"1.1"];
    
    NSSet *cartCollections = [NSSet setWithObject:[ZIMStorageShoppingCartItem collection]];
    [cartView.options setAllowedCollections:[[YapWhitelistBlacklist alloc] initWithWhitelist:cartCollections]];
    [_database registerExtension:cartView withName:ZIMYapShoppingCartViewName];
}

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
