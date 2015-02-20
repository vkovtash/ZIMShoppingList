//
//  YapDatabaseViewConnection+ZIMGetChanges.h
//  ShoppingCart
//
//  Created by kovtash on 18.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "YapDatabaseViewConnection.h"
#import "ZIMListChanges.h"

@interface YapDatabaseViewConnection (ZIMGetChanges)
- (void)zim_getSectionChanges:(NSArray **)sectionChangesPtr
                   rowChanges:(NSArray **)rowChangesPtr
             forNotifications:(NSArray *)notifications
                 withMappings:(YapDatabaseViewMappings *)mappings;
@end
