//
//  UIView+ZIMNibForViewClass.h
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZIMNibForViewClass)
+ (UINib *)zim_getAssociatedNib;
+ (instancetype)zim_loadFromNib;
@end
