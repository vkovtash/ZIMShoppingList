//
//  ZIMYapGoodsItem+ZIMYapRetrieving.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapGoodsItem+ZIMYapRetrieving.h"

@implementation ZIMYapGoodsItem (ZIMYapRetrieving)

- (NSString *)collection {
    return [[self class] collection];
}

+ (instancetype)entityWithKey:(NSString *)key inTransaction:(YapDatabaseReadTransaction *)transaction {
    return [transaction objectForKey:key inCollection:[self collection]];
}

+ (NSString *)collection {
    static NSString *const collection = @"ZIMYapGoodsItem";
    return collection;
}

@end
