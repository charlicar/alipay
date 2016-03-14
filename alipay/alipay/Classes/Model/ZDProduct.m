//
//  ZDProdoct.m
//  alipay
//
//  Created by charlicar on 16/3/14.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import "ZDProduct.h"

@implementation ZDProduct

- (instancetype)initWithName:(NSString *)name price:(double)price detail:(NSString *)detail
{
    if (self = [super init]) {
        self.name = name;
        self.price = price;
        self.detail = detail;
    }
    return self;
}

+ (instancetype)productWithName:(NSString *)name price:(double)price detail:(NSString *)detail
{
    return [[self alloc] initWithName:name price:price detail:detail];
}

@end
