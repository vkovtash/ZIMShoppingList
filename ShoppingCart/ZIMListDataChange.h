//
//  ZIMListDataChange.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ZIMListDataChangeType) {
    ZIMListDataChangeTypeInsert,
    ZIMListDataChangeTypeDelete,
    ZIMListDataChangeTypeUpdate,
    ZIMListDataChangeTypeMove
};


@interface ZIMListDataChange : NSObject
@property (readonly, nonatomic) ZIMListDataChangeType changeType;
@property (readonly, nonatomic) id object;
@property (readonly, nonatomic) NSIndexPath *indexPath;
@property (readonly, nonatomic) NSIndexPath *fromIndexPath;

- (instancetype)initWithChanheType:(ZIMListDataChangeType)changeType
                            object:(id)object
                         indexPath:(NSIndexPath *)indexPath
                     fromIndexPath:(NSIndexPath *)fromIndexPath;

+ (instancetype)newInsertWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newDeleteAIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newUpdateWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newMoveWithObject:(id)object toIndexPath:(NSIndexPath *)indexPath fromIndexPath:(NSIndexPath *)fromIndexPath;
@end
