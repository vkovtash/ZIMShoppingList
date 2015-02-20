//
//  YapDatabaseViewConnection+ZIMGetChanges.m
//  ShoppingCart
//
//  Created by kovtash on 18.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "YapDatabaseViewConnection+ZIMGetChanges.h"

@implementation YapDatabaseViewConnection (ZIMGetChanges)

- (void)zim_getSectionChanges:(NSArray **)sectionChangesPtr
                   rowChanges:(NSArray **)rowChangesPtr
             forNotifications:(NSArray *)notifications
                 withMappings:(YapDatabaseViewMappings *)mappings {
    
    if (notifications.count == 0) {
        return;
    }
    
    NSArray *sectionChanges = nil;
    NSArray *rowChanges = nil;
    
    [self getSectionChanges:&sectionChanges
                 rowChanges:&rowChanges
           forNotifications:notifications
               withMappings:mappings];
    
    if ([sectionChanges count] == 0 & [rowChanges count] == 0) { // Nothing has changed that affects our tableView
        return;
    }
    
    NSMutableArray *zimRowChanges = nil;
    NSMutableArray *zimSectionChanges = nil;
    
    if (sectionChanges.count > 0) {
        zimSectionChanges = [NSMutableArray arrayWithCapacity:sectionChanges.count];
        ZIMListSectionChange *sectionChange = nil;
        
        for (YapDatabaseViewSectionChange *change in sectionChanges) {
            switch (change.type) {
                case YapDatabaseViewChangeInsert:
                    sectionChange = [ZIMListSectionChange newInsertAtIndex:change.index];
                    break;
                    
                case YapDatabaseViewChangeDelete:
                    sectionChange = [ZIMListSectionChange newDeleteAIndex:change.index];
                    break;
                    
                default:
                    sectionChange = nil;
                    break;
            }
            
            if (sectionChange) {
                [zimSectionChanges addObject:sectionChange];
            }
        }
    }
    
    if (rowChanges.count > 0) {
        zimRowChanges = [NSMutableArray arrayWithCapacity:rowChanges.count];
        ZIMListRowChange *rowChange = nil;
        
        for (YapDatabaseViewRowChange *change in rowChanges) {
            if (!(change.changes & YapDatabaseViewChangedObject)) {
                continue;
            }
            
            switch (change.type) {
                case YapDatabaseViewChangeInsert:
                    rowChange = [ZIMListRowChange newInsertAtIndexPath:change.newIndexPath];
                    break;
                    
                case YapDatabaseViewChangeDelete:
                    rowChange = [ZIMListRowChange newDeleteAIndexPath:change.indexPath];
                    break;
                    
                case YapDatabaseViewChangeMove:
                    rowChange = [ZIMListRowChange newMoveToIndexPath:change.newIndexPath
                                                      fromIndexPath:change.indexPath];
                    break;
                    
                case YapDatabaseViewChangeUpdate:
                    rowChange = [ZIMListRowChange newUpdateAtIndexPath:change.indexPath];
                    break;
            }
            
            [zimRowChanges addObject:rowChange];
        }
    }
    
    *rowChangesPtr = zimRowChanges;
    *sectionChangesPtr = zimSectionChanges;
}

@end
