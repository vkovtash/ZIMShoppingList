//
//  ZIMCartItemTableViewCell.m
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import "ZIMCartItemTableViewCell.h"

@implementation ZIMCartItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstTrigger = 0.25;
    self.secondTrigger = 0.5;
    [self setDefaultColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
