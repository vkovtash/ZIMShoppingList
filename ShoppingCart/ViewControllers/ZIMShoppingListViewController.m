//
//  ZIMShoppingListViewController.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMShoppingListViewController.h"
#import "ZIMCartItemTableViewCell.h"
#import "ZIMListControllersFabric.h"
#import "UITableViewController+ZIMListDelegateProtocol.h"

@interface ZIMShoppingListViewController ()
@property (strong, nonatomic) NSString *itemCellClassName;
@end

@implementation ZIMShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemCellClassName =  NSStringFromClass([ZIMCartItemTableViewCell class]);
    
    UINib *itemCellNib =  [UINib nibWithNibName:self.itemCellClassName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:itemCellNib forCellReuseIdentifier:self.itemCellClassName];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newShoppingCartListController];
    self.listController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goodsCatalog"]) {
        UINavigationController *nc = segue.destinationViewController;
        ZIMGoodsCatalogViewController *goodsCatalogViewController = nc.viewControllers.firstObject;
        goodsCatalogViewController.delegate = self;
    }
}

#pragma mark - ZIMGoodsCatalogViewControllerDelegate

- (void) goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items {
    [self.listController appendItems:items];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listController numberofItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMCartItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.itemCellClassName forIndexPath:indexPath];
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]]
                            color:[UIColor greenColor]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
    {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self.listController deleteItemAtIndexPath:indexPath];
    }];
    
    [cell setSwipeGestureWithView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross"]]
                            color:[UIColor redColor]
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState2
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode)
     {
         NSIndexPath *indexPath = [tableView indexPathForCell:cell];
         [self.listController deleteItemAtIndexPath:indexPath];
     }];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ZIMCartItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.listController moveItemFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


@end
