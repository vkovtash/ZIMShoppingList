//
//  ZIMGoodsCatalogViewController.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMListProtocol.h"

@class ZIMGoodsCatalogViewController;

@protocol ZIMGoodsCatalogViewControllerDelegate <NSObject>
- (void) goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items;
@end

@interface ZIMGoodsCatalogViewController : UITableViewController
@property (weak, nonatomic) id <ZIMGoodsCatalogViewControllerDelegate> delegate;
@property (strong, nonatomic) id <ZIMListProtocol> listController;
@end
