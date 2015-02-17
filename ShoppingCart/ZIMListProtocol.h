//
//  ZIMListControllerProtocol.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListDataChange.h"


@protocol ZIMListControllerDelegateProtocol <NSObject>
@optional
- (void)listControllerDidReloadData:(id)listController;
- (void)listController:(id)listController didChangeWithChanges:(NSArray *)changes;
@end


@protocol ZIMListControllerProtocol <NSObject>
@property (weak, nonatomic) id <ZIMListControllerDelegateProtocol> delegate;

- (NSInteger)numberOfSections;
- (NSInteger)numberofItemsInSection:(NSInteger)section;
- (id)objectForSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
