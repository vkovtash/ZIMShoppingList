//
//  ZIMListControllersFabric.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMShoppingCartListProtocol.h"

@protocol ZIMListControllersFabricProtocol <NSObject>
- (id <ZIMShoppingCartListProtocol>)newShoppingCartListController;
- (id <ZIMListProtocol>)newGoodsCatalogListController;
@end
