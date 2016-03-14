//
//  ViewController.m
//  alipay
//
//  Created by charlicar on 16/3/14.
//  Copyright © 2016年 charlicar. All rights reserved.
//

#import "ZDViewController.h"
#import "ZDProduct.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ZDViewController ()
/**商品数组*/
@property (nonatomic,strong)NSArray *products;

@end

@implementation ZDViewController
#pragma mark - lazy
- (NSArray *)products
{
    if (!_products) {
        ZDProduct *product1 = [ZDProduct productWithName:@"商品1" price:100.01 detail:@"测试商品1"];
        ZDProduct *product2 = [ZDProduct productWithName:@"商品2" price:200.02 detail:@"测试商品2"];
        ZDProduct *product3 = [ZDProduct productWithName:@"商品3" price:300.03 detail:@"测试商品3"];
        ZDProduct *product4 = [ZDProduct productWithName:@"商品4" price:400.04 detail:@"测试商品4"];
        ZDProduct *product5 = [ZDProduct productWithName:@"商品5" price:500.05 detail:@"测试商品5"];
        
        _products = @[product1,product2,product3,product4,product5];
    }
    return _products;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"购物商城";
    self.tableView.rowHeight = 70;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"productID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    ZDProduct *product = self.products[indexPath.row];
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",product.price];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - <UITableviewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self buyProduct:self.products[indexPath.row]];
}

#pragma mark - 购买商品
- (void)buyProduct:(ZDProduct *)product
{
    //1.签约后获取到的商户ID和私钥
    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    
    //2.生成订单
    //2.1 创建订单对象
    Order *order = [[Order alloc] init];
    //2.2 设置商户ID和账号ID
    order.partner = partner;
    order.seller = seller;
    //2.3 设置订单号(根据项目自己的算法决定)
    order.tradeNO = nil;
    //2.4 设置商品相关的信息
    order.productName = product.name;
    order.productDescription = product.detail;
    order.amount = [NSString stringWithFormat:@"%.2f",product.price];
    //2.5 设置支付宝回调的URL
    order.notifyURL = @"http://www.xxx.com";//回调URL
    //2.6 支付宝官方规定写法
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //3.添加应用程序的URL Scheme
    NSString *appScheme = @"ZDAPP";
    
    //4.将定义信息拼接成一个字符串
    NSString *orderString = [order description];
    
    //5.对订单进行签名加密
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderString];
    
    //6.将签名成功后的字符串格式化为订单字符串
    NSString *signedorderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderString, signedString, @"RSA"];
    
    //7.调用支付宝客户端,让用户进行支付
    [[AlipaySDK defaultService] payOrder:signedorderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}
@end
