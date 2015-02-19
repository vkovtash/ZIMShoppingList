//
//  ZIMCatalogItemCell.h
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZIMItemCellIndicatorState) {
    ZIMItemCellIndicatorNone,
    ZIMItemCellIndicatorActive,
    ZIMItemCellIndicatorInactive
};


@interface ZIMCatalogItemCell : UITableViewCell
@property (strong, nonatomic) UIColor *activeColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *inactiveColor UI_APPEARANCE_SELECTOR;;
@property (assign, nonatomic) ZIMItemCellIndicatorState indicatorState;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *stateIndicatorView;
@end
