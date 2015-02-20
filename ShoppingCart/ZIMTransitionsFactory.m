//
//  ZIMTransitionsFactory.m
//  ShoppingCart
//
//  Created by kovtash on 20.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMTransitionsFactory.h"
#import "ZFModalTransitionAnimator.h"

@implementation ZIMTransitionsFactory

+ (id<UIViewControllerTransitioningDelegate>)modalTransitionWithViewController:(UIViewController *)viewController {
    ZFModalTransitionAnimator *animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:viewController];
    animator.bounces = NO;
    animator.behindViewAlpha = 0.7f;
    animator.behindViewScale = 0.9f;
    animator.springDamping = 1.0;
    animator.initialSpringVelocity = 0;
    animator.transitionDuration = 0.5;
    animator.direction = ZFModalTransitonDirectionBottom;
    
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = animator;
    
    return animator;
}

@end
