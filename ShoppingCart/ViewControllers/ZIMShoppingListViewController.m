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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listController numberofItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.itemCellClassName forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ZIMCartItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.listController deleteItemAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.listController moveItemFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
