//
//  ZIMYapShoppingCartListController.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMShoppingCartListProtocol.h"
#import "ZIMYapStotage.h"

@interface ZIMYapShoppingCartListController : NSObject <ZIMShoppingCartListProtocol>
@property (readonly, nonatomic) ZIMYapStotage *storage;

- (instancetype)init __attribute__((unavailable("Should be created with initWithStorage:")));
- (instancetype)initWithStorage:(ZIMYapStotage *)storage;
@end
