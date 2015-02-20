//
//  UITableView+ZIMApplyListChanges.m
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "UITableView+ZIMApplyListChanges.h"

@implementation UITableView (ZIMApplyListChanges)

- (void) zim_applyRowChanges:(NSArray *)rowChanges sectionChanges:(NSArray *)sectionChanges {
    [self beginUpdates];
    
    for (ZIMListSectionChange *change in sectionChanges) {
        switch (change.changeType) {
            case ZIMListChangeTypeInsert:
                [self insertSections:[NSIndexSet indexSetWithIndex:change.index] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeDelete:
                [self deleteSections:[NSIndexSet indexSetWithIndex:change.index] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            default:
                break;
        }
    }
    
    for (ZIMListRowChange *change in rowChanges) {
        switch (change.changeType) {
            case ZIMListChangeTypeInsert:
                [self insertRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeDelete:
                [self deleteRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeUpdate:
                break;
                
            case ZIMListChangeTypeMove:
                [self moveRowAtIndexPath:change.fromIndexPath toIndexPath:change.indexPath];
                break;
        }
    }
    [self endUpdates];
}

@end
