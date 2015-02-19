//
//  UIView+ZIMNibForViewClass.m
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "UIView+ZIMNibForViewClass.h"

@implementation UIView (ZIMNibForViewClass)

+ (UINib *)zim_getAssociatedNib {
    return [UINib nibWithNibName:NSStringFromClass(self.class) bundle:[NSBundle mainBundle]];
}

+ (instancetype)zim_loadFromNib {
    NSArray *nibContent = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                                        owner:nil
                                                      options:nil];
    
    return [nibContent firstObject];
}

@end
