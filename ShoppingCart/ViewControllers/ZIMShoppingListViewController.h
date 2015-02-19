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
#import "ZIMCartItemCellConfigurator.h"
#import "HPReorderTableView.h"

@interface ZIMShoppingListViewController : UITableViewController <ZIMGoodsCatalogViewControllerDelegate,
                                                                  ZIMCartItemCellDelegate,
                                                                  ZIMListControllerDelegateProtocol>
@property (strong, nonatomic) IBOutlet HPReorderTableView *tableView;
@property (assign, nonatomic) ZIMListItemState controllerFilterState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (strong, nonatomic) ZIMCartItemCellConfigurator *cellConfigurator;
@property (strong, nonatomic) id <ZIMShoppingCartListProtocol> listController;
@end
