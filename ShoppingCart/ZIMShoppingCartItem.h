//
//  ZIMShoppingCartItem.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMSoppingCartCategory.h"

@interface ZIMShoppingCartItem : NSObject
@property (readonly, nonatomic) NSString *itemId;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) ZIMSoppingCartCategory *category;
@end
