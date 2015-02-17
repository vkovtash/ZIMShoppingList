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

- (void)listController:(id)listController didChangeWithChanges:(NSArray *)changes {
    [self.tableView beginUpdates];
    for (ZIMListDataChange *change in changes) {
        switch (change.changeType) {
            case ZIMListDataChangeTypeInsert:
                [self.tableView insertRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case ZIMListDataChangeTypeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[change.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case ZIMListDataChangeTypeUpdate:
                break;
                
            case ZIMListDataChangeTypeMove:
                [self.tableView moveRowAtIndexPath:change.fromIndexPath toIndexPath:change.indexPath];
                break;
        }
    }
    [self.tableView endUpdates];
}

@end
