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
#import "UIView+ZIMNibForViewClass.h"


static NSString *const ZIMCartItemCellReuseId = @"ZIMCartItemCellReuseId";
static NSString *const ZIMGoodsCatalogSegueId = @"goodsCatalog";


@interface ZIMShoppingListViewController ()
@end

@implementation ZIMShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controllerFilterState = ZIMCartItemStateUndone;
    
    [self.tableView registerNib:[ZIMCartItemTableViewCell zim_getAssociatedNib]
         forCellReuseIdentifier:ZIMCartItemCellReuseId];
    
    self.listController = [[ZIMListControllersFabric sharedFabric] newShoppingCartListController];
}

- (void)dealloc {
    self.listController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ZIMGoodsCatalogSegueId]) {
        UINavigationController *nc = segue.destinationViewController;
        ZIMGoodsCatalogViewController *goodsCatalogViewController = nc.viewControllers.firstObject;
        goodsCatalogViewController.delegate = self;
    }
}

#pragma mark - Public API

- (void)setListController:(id<ZIMShoppingCartListProtocol>)listController {
    if (_listController != listController) {
        _listController.delegate = nil;
        _listController = listController;
        _listController.delegate = self;
        [self applyFilterState];
    }
}

- (void)setControllerFilterState:(ZIMCartItemState)controllerFilterState {
    if (_controllerFilterState != controllerFilterState) {
        _controllerFilterState = controllerFilterState;
        [self applyFilterState];
    }
}

#pragma mark - Actions

- (IBAction)filterControlChanged:(UISegmentedControl *)sender {
    if (sender == self.filterControl) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                self.controllerFilterState = ZIMCartItemStateLater;
                break;
                
            case 2:
                self.controllerFilterState = ZIMCartItemStateDone;
                break;
                
            case 1:
            default:
                self.controllerFilterState = ZIMCartItemStateUndone;
                break;
        }
    }
}

- (IBAction)clearButtonTapped:(UIBarButtonItem *)sender {
    [self.listController removeAllItems];
}

#pragma mark - Private API

- (void)applyFilterState {
    UIColor *newWindowColor = nil;
    
    switch (self.controllerFilterState) {
        case ZIMCartItemStateLater:
            self.filterControl.selectedSegmentIndex = 0;
            self.cellConfigurator = [ZIMCartItemCellConfigurator laterCellConfigurator];
            newWindowColor = self.cellConfigurator.laterColor;
            break;
            
        case ZIMCartItemStateDone:
            self.filterControl.selectedSegmentIndex = 2;
            self.cellConfigurator = [ZIMCartItemCellConfigurator doneCellConfigurator];
            newWindowColor = self.cellConfigurator.doneColor;
            break;
            
        case ZIMCartItemStateUndone:
        default:
            self.filterControl.selectedSegmentIndex = 1;
            self.cellConfigurator = [ZIMCartItemCellConfigurator undoneCellConfigurator];
            newWindowColor = self.cellConfigurator.mainColor;
            break;
    }
    
    if (newWindowColor) {
        [UIApplication sharedApplication].delegate.window.tintColor = newWindowColor;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = (self.controllerFilterState == ZIMCartItemStateUndone);
    self.cellConfigurator.delegate = self;
    [self.listController setItemsStateFilter:self.controllerFilterState];
}

- (void) subscribeListControllerNotifications {
    self.listController.delegate = self;
}

#pragma mark - ZIMGoodsCatalogViewControllerDelegate

- (BOOL)isItemInList:(ZIMShoppingCartItem *)item {
    return [self.listController isItemInList:item];
}

- (void)goodsCatalog:(ZIMGoodsCatalogViewController *)catalog didCompleteWithItemsSelected:(NSArray *)items {
    [self.listController appendItems:items];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZIMCartItemCellDelegate

- (void)deleteAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell; {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.listController removeItemAtIndexPath:indexPath];
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
    cell.itemTitleLabel.text = [item.title capitalizedString];
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
    [self performSelector:@selector(subscribeListControllerNotifications) withObject:self afterDelay:0];
}

@end
