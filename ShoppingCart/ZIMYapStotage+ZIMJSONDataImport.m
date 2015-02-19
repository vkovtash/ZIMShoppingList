//
//  ZIMYapStotage+ZIMJSONDataImport.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMYapStotage+ZIMJSONDataImport.h"
#import "ZIMStorageGoodsItem+ZIMYapRetrieving.h"
#import "ZIMStorageCategory+ZIMYapRetrieving.h"


@implementation ZIMJSONGoodsItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"storageId": @"storage_id",
             @"title": @"title",
             };
}

@end


@implementation ZIMJSONGoodsCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"storageId": @"storage_id",
             @"title": @"title",
             @"items": @"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ZIMJSONGoodsItem class]];
}

@end


@implementation ZIMJSONGoodsDocument

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categories": @"categories",
             };
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ZIMJSONGoodsCategory class]];
}

@end


@implementation ZIMYapStotage (ZIMTestData)

- (BOOL)importDataFromFileWithPath:(NSString *)filePath error:(NSError **)error {
    NSData *JSONData = [[NSData alloc] initWithContentsOfFile:filePath options:0 error:error];
    if (!JSONData) {
        return NO;
    }
    
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:error];
    
    if (!JSONDictionary) {
        return NO;
    }
    
    ZIMJSONGoodsDocument *JSONDocument = [MTLJSONAdapter modelOfClass:ZIMJSONGoodsDocument.class
                                                   fromJSONDictionary:JSONDictionary
                                                                error:error];
    
    if (!JSONDocument) {
        return NO;
    }
    
    for (ZIMJSONGoodsCategory *JSONCategory in JSONDocument.categories) {
        
        [self.bgConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            ZIMYapListCategory *category = [ZIMYapListCategory new];
            category.title = [JSONCategory.title lowercaseString];
            category.categoryKey = JSONCategory.storageId;
            
            [transaction setObject:category forKey:category.categoryKey inCollection:category.collection];
            
            ZIMYapGoodsItem *goodsItem = nil;
            for (ZIMJSONGoodsItem *JSONItem in JSONCategory.items) {
                goodsItem = [ZIMYapGoodsItem new];
                goodsItem.categoryKey = category.categoryKey;
                goodsItem.itemKey = JSONItem.storageId;
                goodsItem.title = [JSONItem.title lowercaseString];
                
                [transaction setObject:goodsItem forKey:goodsItem.itemKey inCollection:goodsItem.collection];
            }
        }];
    }
    
    return YES;
}

@end
