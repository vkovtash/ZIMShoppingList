//
//  ZIMListDataChange.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMListDataChange.h"

@implementation ZIMListDataChange

- (instancetype)initWithChanheType:(ZIMListDataChangeType)changeType
                            object:(id)object
                         indexPath:(NSIndexPath *)indexPath
                     fromIndexPath:(NSIndexPath *)fromIndexPath {
    self = [super init];
    if (self) {
        _changeType = changeType;
        _object = object;
        _indexPath = indexPath;
        _fromIndexPath = fromIndexPath;
    }
    return self;
}

+ (instancetype)newInsertWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListDataChangeTypeInsert object:object indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newDeleteAIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListDataChangeTypeDelete object:nil indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newUpdateWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListDataChangeTypeUpdate object:object indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newMoveWithObject:(id)object toIndexPath:(NSIndexPath *)indexPath fromIndexPath:(NSIndexPath *)fromIndexPath {
    return [[self alloc] initWithChanheType:ZIMListDataChangeTypeMove object:object indexPath:indexPath fromIndexPath:fromIndexPath];
}

@end
