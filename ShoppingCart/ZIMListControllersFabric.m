//
//  ZIMSharedListControllersFabric.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMListControllersFabric.h"

@implementation ZIMListControllersFabric
@synthesize concreteFabric = _concreteFabric;

+ (instancetype) sharedFabric {
    static dispatch_once_t pred;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id <ZIMListControllersFabricProtocol>)concreteFabric {
    @synchronized(self) {
        return _concreteFabric;
    }
}

- (void) setConcreteFabric:(id<ZIMListControllersFabricProtocol>)concreteFabric {
    @synchronized(self) {
        _concreteFabric = concreteFabric;
    }
}

- (id <ZIMShoppingCartListProtocol>)newShoppingCartListController {
    return [self.concreteFabric newShoppingCartListController];
}

- (id <ZIMGoodsCatalogListProtocol>)newGoodsCatalogListController {
    return [self.concreteFabric newGoodsCatalogListController];
}

@end
