//
//  ZIMYapListItem+ZIMYapRetrieving.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapListItem.h"
#import <YapDatabase/YapDatabaseTransaction.h>

@interface ZIMYapListItem (ZIMYapRetrieving)
- (NSString *)collection;
- (BOOL)saveInTransaction:(YapDatabaseReadWriteTransaction *)transaction;
- (void)removeInTransaction:(YapDatabaseReadWriteTransaction *)transaction;

+ (BOOL)entityExistsForKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction;
+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction;
+ (NSString *)collection;
@end
