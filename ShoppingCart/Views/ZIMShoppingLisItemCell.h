//
//  ZIMShoppingLisItemCell.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@interface ZIMShoppingLisItemCell : MCSwipeTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemTitleLabel;
@end
