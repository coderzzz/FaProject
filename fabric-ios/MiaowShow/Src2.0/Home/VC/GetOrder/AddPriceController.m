//
//  AddPriceController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AddPriceController.h"
#import "PPNumberButton.h"
#import "PayTypeViewController.h"
@interface AddPriceController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) PPNumberButton *numberButton;
@end

@implementation AddPriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    [self addNumberBtn];
    self.priceLab.text = [NSString stringWithFormat:@"%@",self.dic[@"orderAmt"]];
}
- (void)addNumberBtn{
    

    _numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(0, 5, 100, 30)];
    //设置边框颜色
    _numberButton.borderColor = [UIColor grayColor];
    _numberButton.increaseTitle = @"＋";
    _numberButton.decreaseTitle = @"－";
    _numberButton.currentNumber = 5;
    _numberButton.minValue = 5;
    _numberButton.delegate = self;
    _numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    
    [self.btnView addSubview:_numberButton];
//    [self calculate];
}



-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}

- (IBAction)pay:(id)sender {
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_addPrice:@{@"custId":user.userId,@"askId":self.dic[@"askId"],@"addPrice":@(_numberButton.currentNumber)} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        if([object[@"ret"] intValue] == 0){
            
            
            [self close:nil];
            PayTypeViewController *pay = [PayTypeViewController new];
            pay.tradeDict = object[@"data"];
            pay.type= @"2";
            [pay show];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

- (IBAction)close:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}



@end
