//
//  ZIMGoodsCatalogListProtocol.h
//  ShoppingCart
//
//  Created by kovtash on 18.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListControllerProtocol.h"

@protocol ZIMGoodsCatalogListProtocol <ZIMListControllerProtocol>
@property (copy, nonatomic) NSString *filterString;
@end
