//
//  ZIMCartItemCellConfigurator.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMCartItemTableViewCell.h"
#import <MZAppearance/MZAppearance.h>


@protocol ZIMCartItemCellDelegate <NSObject>
- (void)deleteAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setUndoneDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setLaterAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
@end

@interface ZIMCartItemCellConfigurator : NSObject
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

@property (weak, nonatomic) id<ZIMCartItemCellDelegate> delegate;

- (void)configureCell:(ZIMCartItemTableViewCell *)cell;

+ (instancetype)undoneCellConfigurator;
+ (instancetype)doneCellConfigurator;
+ (instancetype)laterCellConfigurator;

+ (id)appearance;
@end
