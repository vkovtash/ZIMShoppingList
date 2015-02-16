//
//  ZIMShoppingListViewController.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMShoppingCartListProtocol.h"

@interface ZIMShoppingListViewController : UITableViewController
@property (strong, nonatomic) id <ZIMShoppingCartListProtocol> listController;
@end
