//
//  ChangePViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ChangePViewController.h"



#define validCodeTime 60

@interface ChangePViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *testCodeTextField;


@property (weak, nonatomic) IBOutlet UIButton *registbtn;




@property (nonatomic, strong) NSTimer *timer;



@end

@implementation ChangePViewController
{
    UIButton *getTestCodeBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改手机号码";
    [self setUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}
- (IBAction)regis:(id)sender {
    
    if (self.phoneTextField.text.length>0 && self.testCodeTextField.text.length>0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(changePhone:code:)]) {
            
            [self.delegate changePhone:self.phoneTextField.text code:self.testCodeTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
}

-(void)setUI{
    
//    self.view.backgroundColor = BGColor;
    
    self.registbtn.backgroundColor = MainColor;
    
    
    //获取验证码
    getTestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getTestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getTestCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getTestCodeBtn.backgroundColor = MainColor;
    [self.view addSubview:getTestCodeBtn];
    
    [getTestCodeBtn bk_whenTapped:^{
        
        if (_phoneTextField.text.length != 11) {
            return ;
        }else{
            
            
            NSDictionary *param = @{@"mobile":_phoneTextField.text,@"type":@"3"};
            
            [BAIRUITECH_NetWorkManager FinanceLiveShow_SMSCodeParam:param withSuccessBlock:^(NSDictionary *object) {
                
                YJLog(@"验证码%@",object);
                
                if([object[@"ret"]intValue] == 0){
                    
                    
                    [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
                    
                    //                    [BAIRUITECH_BRTipView showTipTitle:@"验证码发送成功，请注意查收" delay:1];
                    
                    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCntTime) userInfo:nil repeats:YES];
                    [_timer fire];
                    
                    //                    testCodeTextField.text = [NSString stringWithFormat:@"%@",object[@"data"][@"mobileCode"]];
                    
                }else{
                    
                    [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
                }
                
                
            } withFailureBlock:^(NSError *error) {
                
                
                YJLog(@"error %@",error);
                
                
            }];
            
        }
        
    }];
    
    [getTestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self.view).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        
    }];
    
}



#pragma mark - UITextViewDelegate


#pragma mark - incident

- (void)startCntTime{
    static int time=0;
    time++;
    getTestCodeBtn.userInteractionEnabled=NO;
    getTestCodeBtn.alpha = 0.6;
//    [getTestCodeBtn setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"cccccc"] forState:0];
    getTestCodeBtn.titleLabel.text = [NSString stringWithFormat:@"(%d)重新获取",validCodeTime-time];
    [getTestCodeBtn setTitle:[NSString stringWithFormat:@"(%d)重新获取",validCodeTime-time] forState:UIControlStateNormal];
    getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (time == validCodeTime) {
        getTestCodeBtn.userInteractionEnabled=YES;
        getTestCodeBtn.alpha=1;
        [getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:0];
        time=0;
        [getTestCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
        getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_timer invalidate];
        _timer=nil;
    }
}



#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 if (textField == _phoneTextField)
    {
        if (range.location >= 11) {
            return NO;
        }else
        {
            return YES;
        }
    }else if (textField == _testCodeTextField){
        if (range.location>=6) {
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
}




@end
