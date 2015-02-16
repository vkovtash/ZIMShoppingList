//
//  ZIMBasicListControllerFablic.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMBasicListControllerFablic.h"
#import "ZIMBasicShoppingCartListController.h"

@implementation ZIMBasicListControllerFablic

- (id <ZIMShoppingCartListProtocol>)newShoppingCartListController {
    return [ZIMBasicShoppingCartListController new];
}

@end
