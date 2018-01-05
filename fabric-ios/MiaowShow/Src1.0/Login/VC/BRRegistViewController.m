//
//  BRRegistViewController.m
//  HaoLive
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 bairuitech. All rights reserved.
//

#import "BRRegistViewController.h"
//#import "BRValidAccount.h"
//#import "HTMD5.h"
#import "AppDelegate.h"
#import "BRLoginViewController.h"

#define validCodeTime 60
#define GLOBAL_SUBJECT_COLOR @"ff9601"
@interface BRRegistViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *testCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secpsstf;

@property (weak, nonatomic) IBOutlet UIButton *registbtn;

           //获取验证码按钮
//
//    UITextField *passwordTextField;    //密码输入框
//
//    UIButton *registBtn;               //确定注册按钮
//    
//
//

    


@property (nonatomic, strong) NSTimer *timer;


//@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//@property (weak, nonatomic) IBOutlet UITextField *testCodeTextField;
//@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//
//@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//@property (weak, nonatomic) IBOutlet UIButton *testCodeButton;
//@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation BRRegistViewController
{
     UIButton *getTestCodeBtn;  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机注册";
    
    [self setUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    registBtn.enabled = NO;
//    passwordTextField.secureTextEntry = YES;
//    [phoneTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
//    [passwordTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
//    [testCodeTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
//    [nameTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)regis:(id)sender {
    
    if(!(_passwordTextField.text.length >0)){
        
        [self showHint:@"请输入密码"];
        return ;
    }
    
    if(!(_phoneTextField.text.length >0)){
        
        [self showHint:@"请输入手机号码"];
        return ;
    }
    
    if(!(_testCodeTextField.text.length >0)){
        
        [self showHint:@"请输入验证码"];
        return ;
    }
    
    NSDictionary *param = @{@"loginName":_phoneTextField.text,@"loginPass":_passwordTextField.text,@"verifyCode":_testCodeTextField.text};
    
    NSLog(@"%@",param);
    //
    [BAIRUITECH_NetWorkManager FinanceLiveShow_registParam:param withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            //            NSNotificationCenter *notif = [NSNotificationCenter defaultCenter];
            //
            //            [notif addObserver:self selector:@selector(info:) name:@"phoneAndPwd" object:nil];
            
            NSNotification *notice = [NSNotification notificationWithName:@"info" object:nil  userInfo:@{@"phoneTextField":_phoneTextField.text,@"passwordTextField":_passwordTextField.text}];
            
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self showHudInView:self.navigationController.view];
            
            
            
//            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
    

}

-(void)setUI{
    
    self.view.backgroundColor = BGColor;
    
    self.registbtn.backgroundColor = Color;
   
    
    //获取验证码
    getTestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getTestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getTestCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getTestCodeBtn.backgroundColor = Color;
    [self.view addSubview:getTestCodeBtn];
    
    [getTestCodeBtn bk_whenTapped:^{
        
        if (_phoneTextField.text.length != 11) {
            return ;
        }else{
            
            
            NSDictionary *param = @{@"mobile":_phoneTextField.text,@"type":@"1"};
            
            [BAIRUITECH_NetWorkManager FinanceLiveShow_SMSCodeParam:param withSuccessBlock:^(NSDictionary *object) {
                
                YJLog(@"验证码%@",object);
                
                if([object[@"ret"]intValue] == 0){
                    
                    
                      [self showHint:object[@"msg"]];
                    
//                    [BAIRUITECH_BRTipView showTipTitle:@"验证码发送成功，请注意查收" delay:1];
                    
                    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCntTime) userInfo:nil repeats:YES];
                    [_timer fire];
                    
//                    testCodeTextField.text = [NSString stringWithFormat:@"%@",object[@"data"][@"mobileCode"]];
                    
                }else{
                    
                    [self showHint:object[@"msg"]];
                }
                
                
            } withFailureBlock:^(NSError *error) {
                
                
                YJLog(@"error %@",error);
                
                
            }];
            
        }
        
    }];

    [getTestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        

        make.top.equalTo(self.view).offset(41);
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
    if (textField == _passwordTextField) {
        if (range.location < 12) {
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
