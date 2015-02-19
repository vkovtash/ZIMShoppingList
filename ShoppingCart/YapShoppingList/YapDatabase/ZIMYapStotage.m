//
//  ZIMYapStotage.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage.h"


NSString *const ZIMYapGategoriesViewName = @"ZIMYapGategoriesViewName";
NSString *const ZIMYapGoodsViewName = @"ZIMYapGoodsViewName";
NSString *const ZIMYapShoppingCartViewName = @"ZIMYapShoppingCartViewName";
NSString *const ZIMYapShoppingCartByStateViewName = @"ZIMYapShoppingCartByStateViewName";


static YapDatabaseViewGroupingWithObjectBlock categoriesGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMYapListCategory *object) {
    return [object isKindOfClass:[ZIMYapListCategory class]] ? collection : nil;
};

static YapDatabaseViewSortingWithObjectBlock categoriesSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMYapListCategory *object1, NSString *collection2, NSString *key2, ZIMYapListCategory *object2) {
    return [object1.title caseInsensitiveCompare:object2.title];
};

static YapDatabaseViewGroupingWithObjectBlock goodsGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMYapGoodsItem *object) {
    if ([object isKindOfClass:[ZIMYapGoodsItem class]]) {
        return object.categoryKey;
    }
    return nil;
};

static YapDatabaseViewSortingWithObjectBlock goodsSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMYapGoodsItem *object1, NSString *collection2, NSString *key2, ZIMYapGoodsItem *object2) {
    return [object1.title caseInsensitiveCompare:object2.title];
};

static YapDatabaseViewGroupingWithObjectBlock cartGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMYapListItem *object) {
    if ([object isKindOfClass:[ZIMYapListItem class]]) {
        return collection;
    }
    return nil;
};

static YapDatabaseViewGroupingWithObjectBlock cartByStateGroupingBlock = ^NSString *(NSString *collection, NSString *key, ZIMYapListItem *object) {
    if ([object isKindOfClass:[ZIMYapListItem class]]) {
        return [NSString stringWithFormat:@"%ld", object.state];
    }
    return nil;
};

static YapDatabaseViewSortingWithObjectBlock cartSortingBlock = ^NSComparisonResult(NSString *group, NSString *collection1, NSString *key1, ZIMYapListItem *object1, NSString *collection2, NSString *key2, ZIMYapListItem *object2) {
    if (object1.sortOrder > object2.sortOrder) {
        return NSOrderedAscending;
    }
    else if (object1.sortOrder < object2.sortOrder) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
};


@implementation ZIMYapStotage

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        _databaseName = databaseName;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        _databasePath = [baseDir stringByAppendingPathComponent:_databaseName];
        
        [self configureDatabase];
    }
    return self;
}

- (void) configureDatabase {
    _database = [[YapDatabase alloc] initWithPath:_databasePath];
    _bgConnection = [_database newConnection];
    
    YapDatabaseView *categoriesView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:categoriesGroupingBlock]
                                                                        sorting:[YapDatabaseViewSorting withObjectBlock:categoriesSortingBlock]
                                                                     versionTag:@"1.1"];
    
    [_database registerExtension:categoriesView withName:ZIMYapGategoriesViewName];
    
    YapDatabaseView *goodsView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:goodsGroupingBlock]
                                                                   sorting:[YapDatabaseViewSorting withObjectBlock:goodsSortingBlock]
                                                                versionTag:@"1.1"];
    
    [_database registerExtension:goodsView withName:ZIMYapGoodsViewName];
    
    
    YapDatabaseView *cartView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:cartGroupingBlock]
                                                                  sorting:[YapDatabaseViewSorting withObjectBlock:cartSortingBlock]
                                                               versionTag:@"1.1"];
    
    [_database registerExtension:cartView withName:ZIMYapShoppingCartViewName];
    
    YapDatabaseView *cartByStateView = [[YapDatabaseView alloc] initWithGrouping:[YapDatabaseViewGrouping withObjectBlock:cartByStateGroupingBlock]
                                                                         sorting:[YapDatabaseViewSorting withObjectBlock:cartSortingBlock]
                                                                      versionTag:@"1.1"];
    
    [_database registerExtension:cartByStateView withName:ZIMYapShoppingCartByStateViewName];
}

@end
