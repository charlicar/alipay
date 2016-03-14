//
//  ZDProdoct.h
//  alipay
//
//  Created by charlicar on 16/3/14.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDProduct : NSObject
/**价格*/
@property (nonatomic,assign)CGFloat price;
/**名称*/
@property (nonatomic,copy)NSString *name;
/**简介*/
@property (nonatomic,copy)NSString *detail;

- (instancetype)initWithName:(NSString *)name price:(double)price detail:(NSString *)detail;
+ (instancetype)productWithName:(NSString *)name price:(double)price detail:(NSString *)detail;
@end
