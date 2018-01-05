//
//  InComeViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "InComeViewController.h"
#import "FabricWebViewController.h"
@interface InComeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@end

@implementation InComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"收益";
    self.countLab.textColor = MainColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadInCome];
}

- (void)loadInCome{
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_inCome:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            self.countLab.text = [NSString stringWithFormat:@"%@",object[@"data"][@"virTotal"]];
            self.moneyLab.text = [NSString stringWithFormat:@"%@ 元",object[@"data"][@"txMoney"]];
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}

- (IBAction)change:(UIButton *)sender {
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    FabricWebViewController *vc = [[FabricWebViewController alloc]init];
    vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/fmsBusi/beans-recharge.html?userId=%@&token=%@",user.userId,user.token];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)readAction:(id)sender {
}



@end
