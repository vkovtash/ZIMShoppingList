//
//  ZIMSoppingCartCategory.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMSoppingCartCategory.h"

@implementation ZIMSoppingCartCategory

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self.categoryId isEqualToString:[object categoryId]];
}

- (NSUInteger) hash {
    return self.categoryId.hash;
}

@end
