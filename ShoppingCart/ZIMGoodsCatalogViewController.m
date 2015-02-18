//
//  ZIMGoodsCatalogViewController.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMGoodsCatalogViewController.h"
#import "ZIMCartItemTableViewCell.h"
#import "ZIMListControllersFabric.h"

@interface ZIMGoodsCatalogViewController()
@property (strong, nonatomic) NSString *itemCellClassName;
@property (strong, nonatomic) NSMutableOrderedSet *selectedIndexes;
@end

@implementation ZIMGoodsCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndexes = [NSMutableOrderedSet new];
    
    self.itemCellClassName =  NSStringFromClass([ZIMCartItemTableViewCell class]);
    
    UINib *itemCellNib =  [UINib nibWithNibName:self.itemCellClassName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:itemCellNib forCellReuseIdentifier:self.itemCellClassName];
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newGoodsCatalogListController];
    self.listController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.delegate goodsCatalog:self didCompleteWithItemsSelected:nil];
}

- (IBAction)doneButtonTapped:(id)sender {
    NSArray *selectedItems = [self selectedItems];
    [self.delegate goodsCatalog:self didCompleteWithItemsSelected:selectedItems];
}

- (NSArray *)selectedItems {
    NSMutableArray *items = [NSMutableArray array];
    ZIMShoppingCartItem *item = nil;
    
    for (NSIndexPath *indexPath in self.selectedIndexes) {
        item = [self.listController objectAtIndexPath:indexPath];
        if (item) {
            [items addObject:item];
        }
    }
    return [items copy];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.listController.filterString = searchText;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZIMSoppingCartCategory *category = [self.listController objectForSection:section];
    return category.title;
}

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
    
    if ([self.selectedIndexes containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexes containsObject:indexPath]) {
        [self.selectedIndexes removeObject:indexPath];
    }
    else {
        [self.selectedIndexes addObject:indexPath];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ZIMListControllerDelegateProtocol

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
