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
#import "ZIMAppearanceController.h"

static NSString *const ZIMCartItemCellReuseId = @"ZIMCartItemCellReuseId";

@interface ZIMShoppingListViewController () <ZIMCartItemCellDelegate>
@property (strong, nonatomic) ZIMCartItemCellConfigurator *cellConfigurator;
@end

@implementation ZIMShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *itemCellNib =  [UINib nibWithNibName:NSStringFromClass([ZIMCartItemTableViewCell class])
                                         bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:itemCellNib forCellReuseIdentifier:ZIMCartItemCellReuseId];
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newShoppingCartListController];
    self.listController.delegate = self;
    self.filterControl.selectedSegmentIndex = 1;
    [self applyFilterState];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    UIColor *windowColor = [ZIMAppearanceController defaultAppearance].mainColor;
    
    switch (self.filterControl.selectedSegmentIndex) {
        case 0:
            state = ZIMCartItemStateLater;
            self.cellConfigurator = [ZIMCartItemCellConfigurator laterCellConfigurator];
            windowColor = [ZIMAppearanceController defaultAppearance].laterColor;
            break;
            
        case 2:
            state = ZIMCartItemStateDone;
            self.cellConfigurator = [ZIMCartItemCellConfigurator doneCellConfigurator];
            windowColor = [ZIMAppearanceController defaultAppearance].doneColor;
            break;
            
        case 1:
        default:
            self.cellConfigurator = [ZIMCartItemCellConfigurator undoneCellConfigurator];
            state = ZIMCartItemStateUndone;
            windowColor = [ZIMAppearanceController defaultAppearance].mainColor;
            break;
    }
    
    [ZIMAppearanceController defaultAppearance].tintColor = windowColor;
    self.navigationItem.rightBarButtonItem.enabled = state == ZIMCartItemStateUndone;
    self.cellConfigurator.delegate = self;
    [self.listController setItemsStateFilter:state];
}

- (void) subscribeListControllerNotifications {
    self.listController.delegate = self;
}

#pragma mark - ZIMGoodsCatalogViewControllerDelegate

- (BOOL)isItemInList:(ZIMShoppingCartItem *)item {
    return [self.listController isItemsInList:item];
}

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

#pragma mark - TableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listController numberofItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMCartItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIMCartItemCellReuseId
                                                                     forIndexPath:indexPath];
    [self.cellConfigurator configureCell:cell];
    cell.separatorInset = tableView.separatorInset;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ZIMCartItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:[ZIMCartItemTableViewCell class]]) {
        return;
    }
    
    ZIMShoppingCartItem *item = [self.listController objectAtIndexPath:indexPath];
    cell.itemTitleLabel.text = item.title;
    cell.categoryTitleLabel.text = [item.category.title uppercaseString];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //Inhibit all notifications while item movement
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(subscribeListControllerNotifications) object:self];
    self.listController.delegate = nil;
    [self.listController moveItemFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
    //Subscribing to notifications on nex runloop cycle
    [self performSelector:@selector(subscribeListControllerNotifications) withObject:self afterDelay:0.1];
}

@end
