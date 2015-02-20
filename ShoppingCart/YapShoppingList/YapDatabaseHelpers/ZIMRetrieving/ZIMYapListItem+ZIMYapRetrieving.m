//
//  ZIMYapListItem+ZIMYapRetrieving.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapListItem+ZIMYapRetrieving.h"

@implementation ZIMYapListItem (ZIMYapRetrieving)

- (NSString *)collection {
    return [[self class] collection];
}

- (BOOL)saveInTransaction:(YapDatabaseReadWriteTransaction *)transaction {
    if (!self.storageKey) {
        return NO;
    }
    
    [transaction setObject:self forKey:self.storageKey inCollection:self.collection];
    return YES;
}

- (void)removeInTransaction:(YapDatabaseReadWriteTransaction *)transaction {
    [transaction removeObjectForKey:self.storageKey inCollection:self.collection];
}

+ (BOOL)entityExistsForKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction {
    return [transaction hasObjectForKey:key inCollection:[self collection]];
}

+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction {
    return [transaction objectForKey:key inCollection:[self collection]];
}

+ (NSString *)collection {
    static NSString *const collection = @"ZIMYapListItem";
    return collection;
}
@end
