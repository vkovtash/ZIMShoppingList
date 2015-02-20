//
//  ZIMDMListItem.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMDMListItem.h"

@implementation ZIMDMListItem

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self.itemId isEqualToString:[object itemId]];
}

- (NSUInteger) hash {
    return self.itemId.hash;
}

@end
