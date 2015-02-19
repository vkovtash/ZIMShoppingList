//
//  ZIMYapGoodsItem+ZIMYapRetrieving.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapGoodsItem.h"
#import <YapDatabase/YapDatabaseTransaction.h>

@interface ZIMYapGoodsItem (ZIMYapRetrieving)
- (NSString *)collection;

+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction;
+ (NSString *)collection;
@end
