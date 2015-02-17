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

@end
