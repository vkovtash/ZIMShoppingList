//
//  ZIMYapListControllerFablic.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapListControllerFablic.h"
#import "ZIMYapShoppingCartListController.h"
#import "ZIMYapGoodsCatalogListController.h"

@interface ZIMYapListControllerFablic ()

@end

@implementation ZIMYapListControllerFablic

- (instancetype)initWithDatabaseName:(NSString *)datanaseName {
    self = [super init];
    if (self) {
        _storage = [[ZIMYapStotage alloc] initWithDatabaseName:datanaseName];
    }
    return self;
}

- (id <ZIMShoppingCartListProtocol>)newShoppingCartListController {
    return [[ZIMYapShoppingCartListController alloc] initWithStorage:_storage];
}

- (id <ZIMGoodsCatalogListProtocol>)newGoodsCatalogListController {
    return [[ZIMYapGoodsCatalogListController alloc] initWithStorage:_storage];
}

@end
