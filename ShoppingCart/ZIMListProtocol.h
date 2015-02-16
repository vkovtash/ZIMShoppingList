//
//  ZIMListProtocol.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListDataChange.h"


@protocol ZIMListDelegateProtocol <NSObject>
@optional
- (void)listDataReloaded;
- (void)listDataChangedWithChanges:(NSArray *)changes;
@end


@protocol ZIMListProtocol <NSObject>
@property (weak, nonatomic) id <ZIMListDelegateProtocol> delegate;

- (NSInteger)numberOfSections;
- (NSInteger)numberofItemsInSection:(NSInteger)section;
- (id)objectForSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
