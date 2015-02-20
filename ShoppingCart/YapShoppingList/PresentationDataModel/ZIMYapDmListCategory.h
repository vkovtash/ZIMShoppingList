//
//  ZIMYapDmListCategory.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMDMListCategory.h"
#import "ZIMYapListCategory.h"

@interface ZIMYapDmListCategory : ZIMDMListCategory
@property (readonly, nonatomic) ZIMYapListCategory *category;

- (instancetype)init __attribute__((unavailable("Should be created with initWithCategory:")));
- (instancetype)initWithCategory:(ZIMYapListCategory *)category;
@end
