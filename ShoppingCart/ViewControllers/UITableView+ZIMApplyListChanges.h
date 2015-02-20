//
//  UITableView+ZIMApplyListChanges.h
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMShoppingListProtocol.h"

@interface UITableView (ZIMApplyListChanges)
- (void) zim_applyRowChanges:(NSArray *)rowChanges sectionChanges:(NSArray *)sectionChanges;
@end
