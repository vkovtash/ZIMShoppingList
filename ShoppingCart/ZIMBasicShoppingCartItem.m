//
//  ZIMBasicShoppingCartItem.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMBasicShoppingCartItem.h"

@implementation ZIMBasicShoppingCartItem
@synthesize title = _title;

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

@end
