//
//  ZIMYapGoodsCatalogListController.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMGoodsCatalogListProtocol.h"
#import "ZIMYapStotage.h"

@interface ZIMYapGoodsCatalogListController : NSObject <ZIMGoodsCatalogListProtocol>
@property (readonly, nonatomic) ZIMYapStotage *storage;

- (instancetype)init __attribute__((unavailable("Should be created with initWithStorage:")));
- (instancetype)initWithStorage:(ZIMYapStotage *)storage;
@end
