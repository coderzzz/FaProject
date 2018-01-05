//
//  PayTypeViewController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PayTypeViewController.h"

@interface PayTypeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

@end

@implementation PayTypeViewController
{
    NSInteger type;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];

    [self select:self.wechatBtn];
}
-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}

- (IBAction)cancel:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}

- (IBAction)select:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    type = btn.tag;
    [btn setBackgroundImage:[UIImage imageNamed:@"付款方式选择框"] forState:UIControlStateNormal];
    if (type == 0) {
        
        [self.aliBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        
        [self.wechatBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
}

- (IBAction)pay:(UIButton *)sender {

    if (type == 1) {
        
        [self aliPay];
    }else{
        [self wePay];
    }
    [self cancel:nil];
}


- (void)aliPay{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.tradeDict];
    [dic setValue:@"1" forKey:@"payType"];
    [dic setValue:@(0) forKey:@"useBalance"];
    [dic setValue:@"" forKey:@"password"];
    [dic setValue:self.type?self.type:@"1" forKey:@"type"];
    
    NSString *timeTamp = [NSString stringWithFormat:@"%ld",(long)[NSDate date].timeIntervalSince1970 * 1000];
    [dic setValue:timeTamp forKey:@"timestamp"];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_PayData:dic withSuccessBlock:^(NSDictionary *object) {
        
        [self showHint:object[@"msg"]];
        [PayTool aliPayOrder:object[@"data"] callback:^(NSDictionary *resultDic) {
            
//            NSLog(@"%@",resultDic);
        }];
        
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}

- (void)wePay{
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.tradeDict];
    [dic setValue:@"0" forKey:@"payType"];
    [dic setValue:@(0) forKey:@"useBalance"];
    [dic setValue:@"" forKey:@"password"];
    [dic setValue:self.type?self.type:@"1" forKey:@"type"];
    
    NSString *timeTamp = [NSString stringWithFormat:@"%ld",(long)[NSDate date].timeIntervalSince1970 * 1000];
    [dic setValue:timeTamp forKey:@"timestamp"];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_PayData:dic withSuccessBlock:^(NSDictionary *object) {
        [self showHint:object[@"msg"]];
//        NSLog(@"%@",object);
        [PayTool sendWeChatPay:object[@"data"]];
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}

@end
