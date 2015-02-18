//
//  ZIMGoodsCatalogViewController.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMGoodsCatalogListProtocol.h"

@class ZIMGoodsCatalogViewController;
@class ZIMShoppingCartItem;

@protocol ZIMGoodsCatalogViewControllerDelegate <NSObject>
@optional
- (BOOL)isItemInList:(ZIMShoppingCartItem *)item;
- (void)goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items;
@end

@interface ZIMGoodsCatalogViewController : UITableViewController <ZIMListControllerDelegateProtocol>
@property (weak, nonatomic) id<ZIMGoodsCatalogViewControllerDelegate> delegate;
@property (strong, nonatomic) id<ZIMGoodsCatalogListProtocol> listController;
@end
