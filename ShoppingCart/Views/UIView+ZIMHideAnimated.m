//
//  UIView+ZIMHideAnimated.m
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "UIView+ZIMHideAnimated.h"

@implementation UIView (ZIMHideAnimated)

- (void)zim_setHidden:(BOOL)hidden animated:(BOOL)animated {
    if (self.hidden == hidden) {
        return;
    }
    
    if (!animated) {
        self.hidden = hidden;
        return;
    }
    
    if (!hidden) {
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = hidden ? 0. : 1.;
    } completion:^(BOOL finished) {
        self.hidden = hidden;
    }];
}

@end
