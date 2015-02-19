//
//  ZIMShoppingListViewController.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMShoppingCartListProtocol.h"
#import "ZIMGoodsCatalogViewController.h"
#import "ZIMCartItemCellConfigurator.h"
#import "UITableViewController+ZIMListDelegateProtocol.h"
#import "HPReorderTableView.h"

@interface ZIMShoppingListViewController : UITableViewController <ZIMGoodsCatalogViewControllerDelegate, ZIMCartItemCellDelegate>
@property (strong, nonatomic) IBOutlet HPReorderTableView *tableView;
@property (assign, nonatomic) ZIMCartItemState controllerFilterState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *filterControl;
@property (strong, nonatomic) ZIMCartItemCellConfigurator *cellConfigurator;
@property (strong, nonatomic) id <ZIMShoppingCartListProtocol> listController;
@end
