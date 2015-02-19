//
//  ZIMCatalogItemCell.m
//  ShoppingCart
//
//  Created by kovtash on 19.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMCatalogItemCell.h"

static const CGFloat ZIMCatalogItemCellIndicatorSize = 10;

@interface ZIMCatalogItemCell()
@property (strong, nonatomic) CAShapeLayer *indicator;
@end

@implementation ZIMCatalogItemCell

- (void)awakeFromNib {
    // Initialization code
    _indicator = [CAShapeLayer new];
    
    CGFloat size = ZIMCatalogItemCellIndicatorSize;
    CGRect layerBounds = self.stateIndicatorView.bounds;
    CGRect circleRect = CGRectMake((CGRectGetWidth(layerBounds) - size) / 2,
                                   (CGRectGetWidth(layerBounds) - size) / 2,
                                   size,
                                   size);
    
    _indicator.path = [UIBezierPath bezierPathWithOvalInRect:circleRect].CGPath;
    [self.stateIndicatorView.layer addSublayer:self.indicator];
    
    [self applyIndicatorState];
}

- (UIColor *)inactiveColor {
    if (!_inactiveColor) {
        _inactiveColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _inactiveColor;
}

- (UIColor *)activeColor {
    if (!_activeColor) {
        return self.tintColor;
    }
    return _activeColor;
}

- (void)setIndicatorState:(ZIMItemCellIndicatorState)indicatorState {
    _indicatorState = indicatorState;
    [self applyIndicatorState];
}

- (void)applyIndicatorState {
    UIColor *fillColor = nil;
    
    switch (self.indicatorState) {
        case ZIMItemCellIndicatorNone:
            fillColor = [UIColor clearColor];
            break;
            
        case ZIMItemCellIndicatorActive:
            fillColor = self.activeColor;
            break;
        
        case ZIMItemCellIndicatorInactive:
            fillColor = self.inactiveColor;
            break;
    }
    
    self.indicator.fillColor = fillColor.CGColor;
}

@end
