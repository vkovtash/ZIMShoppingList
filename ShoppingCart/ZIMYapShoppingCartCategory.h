//
//  ZIMYapShoppingCartCategory.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMSoppingCartCategory.h"
#import "ZIMStorageCategory.h"

@interface ZIMYapShoppingCartCategory : ZIMSoppingCartCategory
@property (readonly, nonatomic) ZIMStorageCategory *category;

- (instancetype)init __attribute__((unavailable("Should be created with initWithCategory:")));
- (instancetype)initWithCategory:(ZIMStorageCategory *)category;
@end
