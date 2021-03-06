//
//  ZIMShoppingListProtocol.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListControllerProtocol.h"
#import "ZIMDMListItem.h"

typedef NS_ENUM(NSUInteger, ZIMListItemState) {
    ZIMListItemStateUndone,
    ZIMListItemStateDone,
    ZIMListItemStateLater,
};

@protocol ZIMShoppingCartListProtocol <ZIMListControllerProtocol>
@property (readonly, nonatomic) ZIMListItemState itemsStateFilter;

- (void)setItemsStateFilter:(ZIMListItemState)itemsStateFilter;

- (NSInteger)numberOfAllItemsInList;
- (BOOL)isItemInList:(ZIMDMListItem *)item;
- (void)appendItems:(NSArray *)items;
- (void)appendItem:(ZIMDMListItem *)item;
- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeAllItems;
- (void)setState:(ZIMListItemState)state forItemAtIndexPath:(NSIndexPath *)indexPath;
- (ZIMDMListItem *)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
