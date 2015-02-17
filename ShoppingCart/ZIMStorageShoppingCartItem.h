//
//  ZIMSotageListItem.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "MTLModel.h"
#import "ZIMStorageGoodsItem.h"
#import "ZIMShoppingCartListProtocol.h"

@interface ZIMStorageShoppingCartItem : MTLModel
@property (assign, nonatomic) ZIMCartItemState state;
@property (assign, nonatomic) unsigned long sortOrder;
@property (strong, nonatomic) NSString *storageKey;
@end
