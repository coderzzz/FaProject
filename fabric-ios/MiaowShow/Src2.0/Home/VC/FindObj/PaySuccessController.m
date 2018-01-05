//
//  PaySuccessController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PaySuccessController.h"
#import "GetOrderController.h"
@interface PaySuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布成功";

    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"返回-1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",_dic[@"buyer"]];
    self.phone.text = [NSString stringWithFormat:@"%@",_dic[@"phone"]];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@",_dic[@"provinceName"],_dic[@"cityName"],_dic[@"areaName"],_dic[@"address"]];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",_dic[@"finalPrice"]];

    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.btn.layer.borderWidth = 1;
}
-(void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)look:(id)sender {
    
    GetOrderController *vc = [[GetOrderController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
