//
//  ZIMListDataChange.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ZIMListChangeType) {
    ZIMListChangeTypeInsert,
    ZIMListChangeTypeDelete,
    ZIMListChangeTypeUpdate,
    ZIMListChangeTypeMove
};


@interface ZIMListRowChange : NSObject
@property (readonly, nonatomic) ZIMListChangeType changeType;
@property (readonly, nonatomic) NSIndexPath *indexPath;
@property (readonly, nonatomic) NSIndexPath *fromIndexPath;

- (instancetype)initWithChanheType:(ZIMListChangeType)changeType
                         indexPath:(NSIndexPath *)indexPath
                     fromIndexPath:(NSIndexPath *)fromIndexPath;

+ (instancetype)newInsertAtIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newDeleteAIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newUpdateAtIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)newMoveToIndexPath:(NSIndexPath *)indexPath fromIndexPath:(NSIndexPath *)fromIndexPath;
@end


@interface ZIMListSectionChange : NSObject
@property (readonly, nonatomic) NSUInteger index;
@property (readonly, nonatomic) ZIMListChangeType changeType;

- (instancetype)initWithChanheType:(ZIMListChangeType)changeType
                             index:(NSUInteger)index;

+ (instancetype)newInsertAtIndex:(NSUInteger)index;
+ (instancetype)newDeleteAIndex:(NSUInteger)index;
@end
