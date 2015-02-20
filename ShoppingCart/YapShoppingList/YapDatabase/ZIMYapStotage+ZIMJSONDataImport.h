//
//  ZIMYapStotage+ZIMJSONDataImport.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage.h"
#import <Mantle/Mantle.h>


@interface ZIMJSONGoodsItem : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSString *storageId;
@property (strong, nonatomic) NSString *title;
@end


@interface ZIMJSONGoodsCategory : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSString *storageId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *items;
@end


@interface ZIMJSONGoodsDocument : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSArray *categories;
@end


@interface ZIMYapStotage (ZIMJSONDataImport)
- (BOOL)importDataFromFileWithPath:(NSString *)filePath error:(NSError **)error;
@end
