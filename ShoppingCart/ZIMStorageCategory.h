//
//  ZIMStorageCategory.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "MTLModel.h"

@interface ZIMStorageCategory : MTLModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *categoryKey;
@end
