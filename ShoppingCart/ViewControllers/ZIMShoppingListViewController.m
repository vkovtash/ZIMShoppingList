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
#import "ZIMCartItemCellConfigurator.h"

@interface ZIMShoppingListViewController () <ZIMCartItemCellDelegate>
@property (strong, nonatomic) NSString *itemCellClassName;
@property (strong, nonatomic) ZIMCartItemCellConfigurator *cellConfigurator;
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
    self.filterControl.selectedSegmentIndex = 1;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyFilterState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goodsCatalog"]) {
        UINavigationController *nc = segue.destinationViewController;
        ZIMGoodsCatalogViewController *goodsCatalogViewController = nc.viewControllers.firstObject;
        goodsCatalogViewController.delegate = self;
    }
}

#pragma mark - Actions

- (IBAction)filterControlChanhed:(UISegmentedControl *)sender {
    if (sender == self.filterControl) {
        [self applyFilterState];
    }
}

#pragma mark - Private API

- (void)applyFilterState {
    ZIMCartItemState state = ZIMCartItemStateUndone;
    
    switch (self.filterControl.selectedSegmentIndex) {
        case 0:
            state = ZIMCartItemStateLater;
            self.cellConfigurator = [ZIMCartItemCellConfigurator laterCellConfigurator];
            break;
            
        case 2:
            state = ZIMCartItemStateDone;
            self.cellConfigurator = [ZIMCartItemCellConfigurator doneCellConfigurator];
            break;
            
        case 1:
        default:
            self.cellConfigurator = [ZIMCartItemCellConfigurator undoneCellConfigurator];
            state = ZIMCartItemStateUndone;
            break;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = state == ZIMCartItemStateUndone;
    self.cellConfigurator.delegate = self;
    [self.listController setItemsStateFilter:state];
}

#pragma mark - ZIMGoodsCatalogViewControllerDelegate

- (void)goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items {
    [self.listController appendItems:items];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZIMCartItemCellDelegate

- (void)deleteAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell; {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.listController deleteItemAtIndexPath:indexPath];
}

- (void)setDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.listController setState:ZIMCartItemStateDone forItemAtIndexPath:indexPath];
}

- (void)setUndoneDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.listController setState:ZIMCartItemStateUndone forItemAtIndexPath:indexPath];
}

- (void)setLaterAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.listController setState:ZIMCartItemStateLater forItemAtIndexPath:indexPath];
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
    [self.cellConfigurator configureCell:cell];
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
