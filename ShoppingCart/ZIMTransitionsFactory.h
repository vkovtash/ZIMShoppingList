//
//  ZIMTransitionsFactory.h
//  ShoppingCart
//
//  Created by kovtash on 20.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIMTransitionsFactory : NSObject
+ (id<UIViewControllerTransitioningDelegate>)modalTransitionWithViewController:(UIViewController *)viewController;
@end
