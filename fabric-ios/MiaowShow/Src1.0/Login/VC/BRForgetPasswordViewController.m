//
//  BRForgetPasswordViewController.m
//  HaoLive
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 bairuitech. All rights reserved.
//

#import "BRForgetPasswordViewController.h"


#define validCodeTime 60
#define GLOBAL_SUBJECT_COLOR @"ff9601"

@interface BRForgetPasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *testCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *sepasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *donebtn;


@property (nonatomic, strong) NSTimer *timer;


@end

@implementation BRForgetPasswordViewController
{
     UIButton *getTestCodeBtn;          //获取验证码按钮
}
- (IBAction)done:(id)sender {
    
    [self updatePwd:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"重置密码";
    
    [self setUI];

}

#pragma mark -搭建UI
-(void)setUI{

    @weakify(self);
    
    _donebtn.backgroundColor = Color;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //获取验证码
    getTestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [getTestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getTestCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getTestCodeBtn.backgroundColor = Color;
    [self.view addSubview:getTestCodeBtn];
    
    [getTestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo(self.view).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        
    }];
    
    [getTestCodeBtn bk_whenTapped:^{
        
        if (_phoneTextField.text.length != 11) {
            return ;
        }else{
            
            
            NSDictionary *param = @{@"mobile":_phoneTextField.text,@"type":@"0"};
            
            [BAIRUITECH_NetWorkManager FinanceLiveShow_SMSCodeParam:param withSuccessBlock:^(NSDictionary *object) {
                
                YJLog(@"验证码%@",object);
                
                if([object[@"ret"]intValue] == 0){
                    
                    [BAIRUITECH_BRTipView showTipTitle:@"验证码发送成功，请注意查收" delay:1];
                    
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
    
}








- (void)startCntTime{
    
    static int time=0;
    time++;
    getTestCodeBtn.userInteractionEnabled=NO;
    getTestCodeBtn.alpha = 0.6;
//    [getTestCodeBtn setTitleColor:BGColor] forState:0];
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

#pragma mark - 重置密码
-(void)updatePwd:(id)sender{

    if(_phoneTextField.text.length != 11){
        
        [self showHint:@"请输入手机号码"];
        return ;
    }
    if(!(_passwordTextField.text.length >0)){
        
        [self showHint:@"密码不合法"];
        return ;
    }
    if(!(_testCodeTextField.text.length >0)){
        
        [self showHint:@"请输入验证码"];
        return ;
    }

    NSDictionary *param = @{@"phone":_phoneTextField.text,@"newPassword":[_passwordTextField.text md5],@"smsCode":_testCodeTextField.text};
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_resetPasswordParam:param withSuccessBlock:^(NSDictionary *object) {
        
        if([object[@"errorCode"] intValue] == 0){
        
            NSNotification *notice = [NSNotification notificationWithName:@"info" object:nil  userInfo:@{@"phoneTextField":_phoneTextField.text,@"passwordTextField":_passwordTextField.text}];
            
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
        
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _passwordTextField) {
        if (range.location < 20) {
            return YES;
        }else
        {
            return NO;
        }
    }else if (textField == _phoneTextField)
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
