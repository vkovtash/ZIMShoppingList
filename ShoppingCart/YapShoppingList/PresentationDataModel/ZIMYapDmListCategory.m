//
//  ZIMYapDmListCategory.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapDmListCategory.h"

@implementation ZIMYapDmListCategory

- (instancetype)initWithCategory:(ZIMYapListCategory *)category {
    self = [super init];
    if (self) {
        _category = category;
    }
    return self;
}

- (NSString *)title {
    return self.category.title;
}

- (NSString *)categoryId {
    return self.category.categoryKey;
}

@end
