//
//  ZIMShoppingListViewController.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMShoppingListProtocol.h"
#import "ZIMGoodsCatalogViewController.h"
#import "ZIMListItemCellConfigurator.h"
#import "HPReorderTableView.h"

@interface ZIMShoppingListViewController : UITableViewController <ZIMGoodsCatalogViewControllerDelegate,
                                                                  ZIMListItemCellDelegate,
                                                                  ZIMListControllerDelegateProtocol>
@property (strong, nonatomic) IBOutlet HPReorderTableView *tableView;
@property (assign, nonatomic) ZIMListItemState controllerFilterState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (strong, nonatomic) ZIMListItemCellConfigurator *cellConfigurator;
@property (strong, nonatomic) id<ZIMShoppingCartListProtocol> listController;
@end
