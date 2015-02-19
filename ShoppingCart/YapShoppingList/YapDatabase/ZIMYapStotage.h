//
//  ZIMYapStotage.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YapDatabase/YapDatabase.h>
#import <YapDatabase/YapDatabaseView.h>
#import "YapDatabaseViewConnection+ZIMGetChanges.h"
#import "ZIMYapModel+ZIMYapRetrieving.h"


extern NSString *const ZIMYapGategoriesViewName;
extern NSString *const ZIMYapGoodsViewName;
extern NSString *const ZIMYapShoppingCartViewName;
extern NSString *const ZIMYapShoppingCartByStateViewName;


@interface ZIMYapStotage : NSObject
@property (readonly, nonatomic) NSString *databasePath;
@property (readonly, nonatomic) NSString *databaseName;
@property (readonly, nonatomic) YapDatabase *database;
@property (readonly, nonatomic) YapDatabaseConnection *bgConnection;

- (instancetype)init __attribute__((unavailable("Should be created with initWithDatabaseName:")));
- (instancetype)initWithDatabaseName:(NSString *)databaseName;
@end
