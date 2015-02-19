//
//  ZIMYapGoodsCatalogListController.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapGoodsCatalogListController.h"
#import <YapDatabase/YapDatabaseFilteredView.h>
#import "ZIMYapDmListItem.h"
#import "ZIMYapDmListCategory.h"

@interface ZIMYapGoodsCatalogListController()
@property (strong, nonatomic) YapDatabaseViewMappings *mappings;
@property (strong, nonatomic) YapDatabaseConnection *connection;
@property (strong, nonatomic) YapDatabaseFilteredView *filteredView;
@property (strong, nonatomic) NSString *filteredViewName;
@end

@implementation ZIMYapGoodsCatalogListController
@synthesize filterString = _filterString;
@synthesize delegate = _delegate;

- (instancetype)initWithStorage:(ZIMYapStotage *)storage {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _storage = storage;
    _connection = [storage.database newConnection];
    _filteredViewName = [NSUUID UUID].UUIDString;
    
    YapDatabaseViewFiltering *filtering = [YapDatabaseViewFiltering withKeyBlock:^BOOL(NSString *group, NSString *collection, NSString *key) {
        return YES;
    }];
    
    _filteredView = [[YapDatabaseFilteredView alloc] initWithParentViewName:ZIMYapGoodsViewName
                                                                  filtering:filtering];
    
    _filteredView.options.isPersistent = NO;
    [_storage.database registerExtension:_filteredView withName:_filteredViewName];
    
    YapDatabaseViewMappingGroupFilter groupFilterBlock = ^BOOL(NSString *group, YapDatabaseReadTransaction *transaction) {
        return YES;
    };
    
    YapDatabaseViewMappingGroupSort groupSortingBlock = ^NSComparisonResult(NSString *group1, NSString *group2, YapDatabaseReadTransaction *transaction){
        ZIMYapListCategory *category1 = [ZIMYapListCategory entityWithKey:group1 inTransaction:transaction];
        ZIMYapListCategory *category2 = [ZIMYapListCategory entityWithKey:group2 inTransaction:transaction];
        return [category1.title caseInsensitiveCompare:category2.title];
    };
    
    _mappings = [[YapDatabaseViewMappings alloc] initWithGroupFilterBlock:groupFilterBlock sortBlock:groupSortingBlock view:_filteredViewName];
    
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
    [self.storage.database unregisterExtensionWithName:self.filteredViewName];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateViewFilter {
    YapDatabaseViewFiltering *filtering = nil;
    NSString *filterString = [self.filterString copy];
    
    if (self.filterString.length > 0) {
        filtering = [YapDatabaseViewFiltering withObjectBlock:^BOOL(NSString *group, NSString *collection, NSString *key, ZIMYapGoodsItem *object) {
            return [object.title containsString:filterString];
        }];
    }
    else {
        filtering = [YapDatabaseViewFiltering withKeyBlock:^BOOL(NSString *group, NSString *collection, NSString *key) {
            return YES;
        }];
    }
    
    [self.storage.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [[transaction ext:self.filteredViewName] setFiltering:filtering versionTag:filterString];
    }];
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

#pragma mark - ZIMGoodsCatalogListProtocol

- (void)setFilterString:(NSString *)filterString {
    NSString *lowerCaseString = [filterString lowercaseString];
    if (![_filterString isEqualToString:lowerCaseString]) {
        _filterString = lowerCaseString;
        [self updateViewFilter];
    }
}

#pragma mark - ZIMListControllerProtocol

- (NSInteger)numberOfSections {
    return [self.mappings numberOfSections];
}

- (NSInteger)numberofItemsInSection:(NSInteger)section {
    return [self.mappings numberOfItemsInSection:section];
}

- (id)objectForSection:(NSInteger)section {
    __block ZIMYapDmListCategory *resultItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMYapGoodsItem *goodsItem = [[transaction ext:self.mappings.view] objectAtRow:0 inSection:section withMappings:self.mappings];
        ZIMYapListCategory *category = [ZIMYapListCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        resultItem = [[ZIMYapDmListCategory alloc] initWithCategory:category];
    }];
    return resultItem;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    __block ZIMYapDmListItem *resultItem = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        ZIMYapGoodsItem *goodsItem = [[transaction ext:self.mappings.view] objectAtIndexPath:indexPath withMappings:self.mappings];
        ZIMYapListCategory *category = [ZIMYapListCategory entityWithKey:goodsItem.categoryKey inTransaction:transaction];
        
        resultItem = [[ZIMYapDmListItem alloc] initWithGoodsItem:goodsItem category:category];
    }];
    return resultItem;
}

@end
