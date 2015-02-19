//
//  ZIMGoodsCatalogViewController.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMGoodsCatalogListProtocol.h"
#import "UITableViewController+ZIMListDelegateProtocol.h"

@class ZIMGoodsCatalogViewController;
@class ZIMDMListItem;

@protocol ZIMGoodsCatalogViewControllerDelegate <NSObject>
@optional
- (BOOL)isItemInList:(ZIMDMListItem *)item;
- (void)goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items;
@end

@interface ZIMGoodsCatalogViewController : UITableViewController <ZIMListControllerDelegateProtocol>
@property (weak, nonatomic) id<ZIMGoodsCatalogViewControllerDelegate> delegate;
@property (strong, nonatomic) id<ZIMGoodsCatalogListProtocol> listController;
@property (copy, nonatomic) NSString *searchString;
@property (readonly, nonatomic) NSOrderedSet *pickedItems;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)pickItem:(ZIMDMListItem *)item;
- (void)releaseItem:(ZIMDMListItem *)item;
- (void)completeItemsPicking;
- (void)cancelItemsPicking;
@end
