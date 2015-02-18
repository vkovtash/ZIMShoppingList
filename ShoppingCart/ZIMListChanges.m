//
//  ZIMListDataChange.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMListChanges.h"

@implementation ZIMListRowChange

- (instancetype)initWithChanheType:(ZIMListChangeType)changeType
                         indexPath:(NSIndexPath *)indexPath
                     fromIndexPath:(NSIndexPath *)fromIndexPath {
    self = [super init];
    if (self) {
        _changeType = changeType;
        _indexPath = indexPath;
        _fromIndexPath = fromIndexPath;
    }
    return self;
}

+ (instancetype)newInsertAtIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListChangeTypeInsert indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newDeleteAIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListChangeTypeDelete indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newUpdateAtIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithChanheType:ZIMListChangeTypeUpdate indexPath:indexPath fromIndexPath:nil];
}

+ (instancetype)newMoveToIndexPath:(NSIndexPath *)indexPath fromIndexPath:(NSIndexPath *)fromIndexPath {
    return [[self alloc] initWithChanheType:ZIMListChangeTypeMove indexPath:indexPath fromIndexPath:fromIndexPath];
}

@end


@implementation ZIMListSectionChange

- (instancetype)initWithChanheType:(ZIMListChangeType)changeType
                             index:(NSUInteger)index {
    self = [super init];
    if (self) {
        _changeType = changeType;
        _index = index;
    }
    return self;
}

+ (instancetype)newInsertAtIndex:(NSUInteger)index {
    return [[[self class] alloc] initWithChanheType:ZIMListChangeTypeInsert index:index];
}

+ (instancetype)newDeleteAIndex:(NSUInteger)index {
    return [[[self class] alloc] initWithChanheType:ZIMListChangeTypeDelete index:index];
}

@end