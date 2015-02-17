//
//  ZIMCartItemCellConfigurator.h
//  ShoppingCart
//
//  Created by kovtash on 17.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMCartItemTableViewCell.h"

@protocol ZIMCartItemCellDelegate <NSObject>
- (void)deleteAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setUndoneDoneAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
- (void)setLaterAtcionTriggeredForCell:(ZIMCartItemTableViewCell *)cell;
@end

@interface ZIMCartItemCellConfigurator : NSObject
@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) UIColor *undoneColor;
@property (strong, nonatomic) UIColor *doneColor;
@property (strong, nonatomic) UIColor *laterColor;
@property (strong, nonatomic) UIColor *deleteColor;
@property (strong, nonatomic) UIImage *laterImage;
@property (strong, nonatomic) UIImage *undoneImage;
@property (strong, nonatomic) UIImage *doneImage;
@property (strong, nonatomic) UIImage *deleteImage;
@property (assign, nonatomic) CGFloat firstTrigger;
@property (assign, nonatomic) CGFloat secondTrigger;

@property (weak, nonatomic) id<ZIMCartItemCellDelegate> delegate;

- (void)configureCell:(ZIMCartItemTableViewCell *)cell;

+ (instancetype)undoneCellConfigurator;
+ (instancetype)doneCellConfigurator;
+ (instancetype)laterCellConfigurator;
@end
