//
//  ZIMListItemCellConfigurator.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMShoppingLisItemCell.h"
#import <MZAppearance/MZAppearance.h>


@protocol ZIMListItemCellDelegate <NSObject>
- (void)deleteAtcionTriggeredForCell:(ZIMShoppingLisItemCell *)cell;
- (void)setDoneAtcionTriggeredForCell:(ZIMShoppingLisItemCell *)cell;
- (void)setUndoneDoneAtcionTriggeredForCell:(ZIMShoppingLisItemCell *)cell;
- (void)setLaterAtcionTriggeredForCell:(ZIMShoppingLisItemCell *)cell;
@end

@interface ZIMListItemCellConfigurator : NSObject
@property (strong, nonatomic) UIColor *defaultColor MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *mainColor MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *doneColor MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *laterColor MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *deleteColor MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage *laterImage MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage *undoneImage MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage *doneImage MZ_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIImage *deleteImage MZ_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat firstTrigger MZ_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat secondTrigger MZ_APPEARANCE_SELECTOR;

@property (weak, nonatomic) id<ZIMListItemCellDelegate> delegate;

- (void)configureCell:(ZIMShoppingLisItemCell *)cell;

+ (instancetype)undoneCellConfigurator;
+ (instancetype)doneCellConfigurator;
+ (instancetype)laterCellConfigurator;

+ (id)appearance;
@end
