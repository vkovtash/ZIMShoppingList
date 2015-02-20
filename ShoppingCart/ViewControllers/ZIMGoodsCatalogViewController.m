//
//  ZIMGoodsCatalogViewController.m
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMGoodsCatalogViewController.h"
#import "ZIMListControllersFabric.h"
#import "ZIMCatalogItemCell.h"
#import "UIView+ZIMNibForViewClass.h"
#import "UITableView+ZIMApplyListChanges.h"


static NSString *const ZIMGoodsItemCellReuseId = @"ZIMGoodsItemCellReuseId";


@interface ZIMGoodsCatalogViewController()
@property (strong, nonatomic) NSMutableOrderedSet *mutablePickedItems;
@end

@implementation ZIMGoodsCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mutablePickedItems = [NSMutableOrderedSet new];
    
    _searchBar = [UISearchBar new];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.tableView registerNib:[ZIMCatalogItemCell zim_getAssociatedNib] forCellReuseIdentifier:ZIMGoodsItemCellReuseId];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newGoodsCatalogListController];
}

- (void)dealloc {
    self.listController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavigationItemsState];
}

#pragma mark - Public API

- (void)setListController:(id<ZIMGoodsCatalogListProtocol>)listController {
    if (_listController != listController) {
        _listController.delegate = nil;
        _listController = listController;
        _listController.delegate = self;
    }
}

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

- (void)pickItem:(ZIMDMListItem *)item {
    if (!item) {
        return;
    }
    [self.mutablePickedItems addObject:item];
    [self updateNavigationItemsState];
}

- (void)releaseItem:(ZIMDMListItem *)item {
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

#pragma mark - ZIMListControllerDelegateProtocol

- (void)listControllerDidReloadData:(id)listController {
    [self.tableView reloadData];
}

- (void)listController:(id)listController didChangeWithRowChanges:(NSArray *)rowChanges sectionChanges:(NSArray *)sectionChanges {
    [self.tableView zim_applyRowChanges:rowChanges sectionChanges:sectionChanges];
}

#pragma mark - TableView DataSource/Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZIMDMListCategory *category = [self.listController objectForSection:section];
    return [category.title uppercaseString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listController numberofItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:ZIMGoodsItemCellReuseId forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ZIMCatalogItemCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMDMListItem *item = [self.listController objectAtIndexPath:indexPath];
    cell.titleLabel.text = [item.title capitalizedString];
    
    BOOL isItemInList = NO;
    if ([self.delegate respondsToSelector:@selector(isItemInList:)]) {
        isItemInList = [self.delegate isItemInList:item];
    }
    
    if (isItemInList) {
        cell.indicatorState = ZIMItemCellIndicatorInactive;
    }
    else if ([self.mutablePickedItems containsObject:item]) {
        cell.indicatorState = ZIMItemCellIndicatorActive;
    }
    else {
        cell.indicatorState = ZIMItemCellIndicatorNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldHighlight = YES;
    if ([self.delegate respondsToSelector:@selector(isItemInList:)]) {
        ZIMDMListItem *item = [self.listController objectAtIndexPath:indexPath];
        shouldHighlight = ![self.delegate isItemInList:item];
    }
    return shouldHighlight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMDMListItem *item = [self.listController objectAtIndexPath:indexPath];
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

@end
