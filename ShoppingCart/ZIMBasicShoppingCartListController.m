//
//  ZIMShoppingCartListController.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMBasicShoppingCartListController.h"
#import "ZIMBasicShoppingCartItem.h"
#import <UIKit/UITableView.h>

@interface ZIMBasicShoppingCartListController()
@end

@implementation ZIMBasicShoppingCartListController
@synthesize delegate = _delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableOrderedSet new];
        
        [_items addObjectsFromArray:@[[[ZIMBasicShoppingCartItem alloc] initWithTitle:@"qwe"],
                                      [[ZIMBasicShoppingCartItem alloc] initWithTitle:@"asd"],
                                      [[ZIMBasicShoppingCartItem alloc] initWithTitle:@"zxc"],
                                      ]];
    }
    return self;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberofItemsInSection:(NSInteger)section {
    return section == 0 ? self.items.count : 0;
}

- (ZIMShoppingCartItem *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return nil;
    }
    return self.items[indexPath.row];
}

- (id)objectForSection:(NSInteger)section {
    return nil;
}

- (void)appendItems:(NSArray *)items {
    for (id item in [items reverseObjectEnumerator]) {
        [self.items insertObject:item atIndex:0];
    }
}

- (void)appendItem:(ZIMShoppingCartItem *)item {
    [self.items insertObject:item atIndex:0];
    if ([self.delegate respondsToSelector:@selector(listDataChangedWithChanges:)]) {
        ZIMListDataChange *dataChange = [ZIMListDataChange newInsertWithObject:item atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.delegate listDataChangedWithChanges:@[dataChange]];
    }
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id item = self.items[fromIndexPath.row];
    [self.items removeObjectAtIndex:fromIndexPath.row];
    [self.items insertObject:item atIndex:toIndexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(listDataChangedWithChanges:)]) {
        ZIMListDataChange *dataChange = [ZIMListDataChange newMoveWithObject:item toIndexPath:toIndexPath fromIndexPath:fromIndexPath];
        [self.delegate listDataChangedWithChanges:@[dataChange]];
    }
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.items removeObjectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(listDataChangedWithChanges:)]) {
        ZIMListDataChange *dataChange = [ZIMListDataChange newDeleteAIndexPath:indexPath];
        [self.delegate listDataChangedWithChanges:@[dataChange]];
    }
}

- (void)setStateForItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
