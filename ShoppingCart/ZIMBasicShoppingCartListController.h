//
//  ZIMShoppingCartListController.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMShoppingCartListProtocol.h"

@interface ZIMBasicShoppingCartListController : NSObject <ZIMShoppingCartListProtocol>
@property (readonly, nonatomic) NSMutableOrderedSet *items;
@end
