//
//  ZIMYapListCategory+ZIMYapRetrieving.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapListCategory.h"
#import <YapDatabase/YapDatabaseTransaction.h>

@interface ZIMYapListCategory (ZIMYapRetrieving)
- (NSString *)collection;

+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction;
+ (NSString *)collection;
@end
