//
//  ZIMStorageGoodsItem+ZIMYapRetrieving.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMStorageGoodsItem.h"
#import <YapDatabase/YapDatabaseTransaction.h>

@interface ZIMStorageGoodsItem (ZIMYapRetrieving)
- (NSString *)collection;

+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction;
+ (NSString *)collection;
@end
