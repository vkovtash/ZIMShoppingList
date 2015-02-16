//
//  ZIMSharedListControllersFabric.h
//  ShoppingCart
//
//  Created by kovtash on 16.02.15.
//  Copyright (c) 2015 zim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMListControllersFabricProtocol.h"

@interface ZIMListControllersFabric : NSObject <ZIMListControllersFabricProtocol>
@property (readonly, nonatomic) id<ZIMListControllersFabricProtocol> concreteFabric;

- (void) setConcreteFabric:(id<ZIMListControllersFabricProtocol>)concreteFabric;
+ (instancetype) sharedFabric;
@end
