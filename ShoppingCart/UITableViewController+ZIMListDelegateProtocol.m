//
//  UITableViewController+ZIMListDelegateProtocol.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "UITableViewController+ZIMListDelegateProtocol.h"

@implementation UITableViewController (ZIMListDelegateProtocol)

- (void)listControllerDidReloadData:(id)listController {
    [self.tableView reloadData];
}

- (void)listController:(id)listController didChangeWithRowChanges:(NSArray *)rowChanges sectionChanges:(NSArray *)sectionChanges {
    [self.tableView beginUpdates];
    
    for (ZIMListSectionChange *change in sectionChanges) {
        switch (change.changeType) {
            case ZIMListChangeTypeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:change.index] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:change.index] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            default:
                break;
        }
    }
    
    for (ZIMListRowChange *change in rowChanges) {
        switch (change.changeType) {
            case ZIMListChangeTypeInsert:
                [self.tableView insertRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case ZIMListChangeTypeUpdate:
                break;
                
            case ZIMListChangeTypeMove:
                [self.tableView moveRowAtIndexPath:change.fromIndexPath toIndexPath:change.indexPath];
                break;
        }
    }
    [self.tableView endUpdates];
}

@end
