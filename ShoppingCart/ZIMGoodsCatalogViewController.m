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

static NSString *const ZIMGoodsItemCellReuseId = @"ZIMGoodsItemCellReuseId";

@interface ZIMGoodsCatalogViewController()
@property (strong, nonatomic) NSMutableOrderedSet *mutablePickedItems;
@end

@implementation ZIMGoodsCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mutablePickedItems = [NSMutableOrderedSet new];
    
    UINib *itemCellNib =  [UINib nibWithNibName:NSStringFromClass([ZIMCartItemTableViewCell class])
                                         bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:itemCellNib forCellReuseIdentifier:ZIMGoodsItemCellReuseId];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newGoodsCatalogListController];
    self.listController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavigationItemsState];
}

#pragma mark - Public API

- (void)setSearchString:(NSString *)searchString {
    _searchString = [searchString copy];
    if (![self.searchBar.text isEqualToString:_searchString]) {
        self.searchBar.text = _searchString;
    }
    
    self.listController.filterString = _searchString;
}

- (NSOrderedSet *)pickedItems {
    return self.mutablePickedItems;
}

- (void)completeItemsPicking {
    [self.searchBar resignFirstResponder];
    
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self.mutablePickedItems) {
        [result addObject:object];
    }
    [self.delegate goodsCatalog:self didCompleteWithItemsSelected:result];
}

- (void)cancelItemsPicking {
    [self.searchBar resignFirstResponder];
    [self.delegate goodsCatalog:self didCompleteWithItemsSelected:nil];
}

- (void)pickItem:(ZIMShoppingCartItem *)item {
    if (!item) {
        return;
    }
    [self.mutablePickedItems addObject:item];
    [self updateNavigationItemsState];
}

- (void)releaseItem:(ZIMShoppingCartItem *)item {
    if (!item) {
        return;
    }
    [self.mutablePickedItems removeObject:item];
    [self updateNavigationItemsState];
}

#pragma mark - Private API

- (void)updateNavigationItemsState {
    self.navigationItem.rightBarButtonItem.enabled = self.mutablePickedItems.count > 0;
}

#pragma mark - Actions

- (IBAction)cancelButtonTapped:(id)sender {
    [self cancelItemsPicking];
}

- (IBAction)doneButtonTapped:(id)sender {
    [self completeItemsPicking];
}

#pragma mark - UISearchbarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchString = searchText;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIMGoodsItemCellReuseId forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ZIMCartItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    
    BOOL isItemInList = NO;
    if ([self.delegate respondsToSelector:@selector(isItemInList:)]) {
        isItemInList = [self.delegate isItemInList:item];
    }
    
    if (isItemInList) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([self.mutablePickedItems containsObject:item]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldHighlight = YES;
    if ([self.delegate respondsToSelector:@selector(isItemInList:)]) {
        ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
        shouldHighlight = ![self.delegate isItemInList:item];
    }
    return shouldHighlight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
    if ([self.mutablePickedItems containsObject:item]) {
        [self releaseItem:item];
    }
    else {
        [self pickItem:item];
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
