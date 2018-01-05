//
//  BRLoginViewController.m
//  HaoLive
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 bairuitech. All rights reserved.
//

#import "BRLoginViewController.h"
#import "BRForgetPasswordViewController.h"
#import "BRRegistViewController.h"
#import "BAIRUITECH_BRAccoutTool.h"
#import "BAIRUITECH_BRAccount.h"
#import "AppDelegate.h"

//#import "UMSocial.h"
#import "MainViewController.h"

#define NUMBERS @"0123456789\n"

@interface BRLoginViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *BbHUD;
    
    UIImageView *bkImgView;        //背景图片
    UIButton *exitBtn;             //退出按钮
    UIImageView *iconImgView;      //icon
    
    UIImageView *phoneImgView;     //手机号码图片
    //UITextField *phoneTextField;   //手机号码输入框
    UIView *line1View;             //手机号码分隔线

    UIImageView *pwdImgView;       //密码图片
    //UITextField *passwordTextField;//密码输入框
    UIButton *eyeBtn;              //密码可见或不可见
    UIView *line2View;             //密码分隔线
    
    UIButton *loginButton;         //登录按钮
    UIButton *registButton;        //注册按钮
    UIButton *forgetPwdButton;     //忘记密码按钮
    
    UIView *line3View;             //第三方登陆
    UIView *line4View;
    UILabel *thirdLoginLabel;
    UIButton *weixinBtn;
    UIButton *qqBtn;
    UIButton *weiboBtn;
    
    MBProgressHUD *HUD;
}



@end

@implementation BRLoginViewController

@synthesize phoneTextField;
@synthesize passwordTextField;
- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    self.title = @"登录";
    
    [self.view bringSubviewToFront:self.btn];
//    phoneTextField.text = @"13632269122";
//    passwordTextField.text = @"123456";
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
     [center addObserver:self selector:@selector(notice:) name:@"info" object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    passwordTextField.secureTextEntry = YES;
//    [phoneTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
//    [passwordTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

#pragma mark -notice
-(void)notice:(NSNotification *)sender{
    
    NSDictionary *dict = sender.userInfo;
    
    phoneTextField.text = dict[@"phoneTextField"];

    passwordTextField.text = dict[@"passwordTextField"];
    
    loginButton.enabled = YES;
    [self hideHud];
    [self login:nil];
//    [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮"] forState:UIControlStateNormal];
//    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark -UI搭建
-(void)setUI{

    @weakify(self);

    //背景图片
//    bkImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG"]];
//    
//    bkImgView.frame = CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT);
//    [self.view addSubview:bkImgView];
    
    //icon
//    iconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOGO-"]];
    iconImgView = [[UIImageView alloc]init];
    iconImgView.image = [UIImage imageNamed:@"头像-4"];
    
    [self.view addSubview:iconImgView];
    
//    if(IS_IPHONE_5){
//    
//        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            @strongify(self);
//            
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//            make.top.equalTo(self.view.mas_top).offset(50);
//            make.width.mas_equalTo(@75);
//            make.height.mas_equalTo(@75);
//        }];
//    }else{
    
        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(50);
            make.width.mas_equalTo(@75);
            make.height.mas_equalTo(@75);
        }];
        
//    }
    

    //手机号码
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.placeholder = @"请输入手机号";
    phoneTextField.delegate = self;
    phoneTextField.textColor = [UIColor darkGrayColor];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    [phoneTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [phoneTextField setValue:[UIFont systemFontOfSize:12]   forKeyPath:@"_placeholderLabel.font"];
//    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [phoneTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:phoneTextField];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(iconImgView).offset(50);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@35);
    }];
    
    
    
  
    //分隔线1
    line1View = [[UIView alloc]init];
    line1View.backgroundColor = BGColor;
    
    [self.view addSubview:line1View];
    
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(phoneTextField.mas_bottom).offset(5);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@1);
        
    }];
    
    
    
    //密码输入框
    passwordTextField = [[UITextField alloc]init];
    passwordTextField.textColor = [UIColor darkGrayColor];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    [passwordTextField setValue:[UIFont systemFontOfSize:12]   forKeyPath:@"_placeholderLabel.font"];
    passwordTextField.placeholder = @"请输入6~12位密码";
    [passwordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    [passwordTextField addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordTextField];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self);
        
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(line1View.mas_bottom).offset(5);
//        make.bottom.equalTo(pwdImgView);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@35);
    }];
    
    //密码可见或不可见
    eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:[UIImage imageNamed:@"闭眼ICO"] forState:UIControlStateNormal];
    
    [eyeBtn bk_whenTapped:^{
        
        NSString *passStr = passwordTextField.text; //切换的时候记录之前的密码
        passwordTextField.text = @"";
        passwordTextField.text = passStr;
        
        eyeBtn.selected = !eyeBtn.selected;
        
        passwordTextField.secureTextEntry = !passwordTextField.secureTextEntry;
        
        if(eyeBtn.selected){
            
            [eyeBtn setImage:[UIImage imageNamed:@"眼睛-ICO"] forState:UIControlStateNormal];
           // passwordTextField.secureTextEntry = NO;
        }else{
            
            [eyeBtn setImage:[UIImage imageNamed:@"闭眼ICO"] forState:UIControlStateNormal];
          //  passwordTextField.secureTextEntry = YES;
        }
    }];
    [self.view addSubview:eyeBtn];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        
        make.top.equalTo(line1View.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    //密码分隔线
    line2View = [[UIView alloc]init];
    line2View.backgroundColor = BGColor;
    
    [self.view addSubview:line2View];
    
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(passwordTextField.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@1);
        
    }];
    
    //登陆按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
//    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
//    [loginButton setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"c5c5c5"] forState:UIControlStateNormal];
//    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    loginButton.enabled = NO;

    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    
//    if(IS_IPHONE_5){
//    
//        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            @strongify(self);
//            make.left.equalTo(self.view.mas_left).offset(20);
//            make.top.equalTo(line2View.mas_bottom).offset(40);
//            make.right.equalTo(self.view.mas_right).offset(-20);
//            make.height.equalTo(@35);
//        }];
//    }else{
//    
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.left.equalTo(self.view.mas_left).offset(20);
            make.top.equalTo(line2View.mas_bottom).offset(40);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.height.equalTo(@35);
        }];
//    }
    
    //注册按钮
    registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    registButton.titleLabel.font = [UIFont systemFontOfSize:15];
    registButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [registButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [registButton bk_whenTapped:^{
        
        @strongify(self);
        BRRegistViewController *registVC = [[BRRegistViewController alloc] init];
        
        [self.navigationController pushViewController:registVC animated:YES];
        

    }];
    
    [self.view addSubview:registButton];
    
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        //make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    //忘记密码
    forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:15];
    forgetPwdButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [forgetPwdButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //点击忘记密码按钮跳转到忘记密码界面
    [forgetPwdButton bk_whenTapped:^{
        
        @strongify(self);
        
        BRForgetPasswordViewController *forgetVC = [[BRForgetPasswordViewController alloc] init];
        
        [self.navigationController pushViewController:forgetVC animated:YES];

    }];
    
    
    [self.view addSubview:forgetPwdButton];
    
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(loginButton.mas_bottom).offset(20);
        //make.width.equalTo(@100);
        make.height.equalTo(@20);
        
    }];
    
    //第三方登陆
    //暂时隐藏QQ和微博
//    
//    qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [qqBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
//    [self.view addSubview:qqBtn];
//    
//    [qqBtn addTarget:self action:@selector(qqLoginClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
//        make.width.equalTo(@50);
//        make.height.equalTo(@50);
//    }];
//    
//    weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//    
//    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:weixinBtn];
//    
//    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.left.equalTo(self.view.mas_left).offset(60);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
//        make.width.equalTo(@50);
//        make.height.equalTo(@50);
//    }];
//    
//    
//    weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weiboBtn setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
//    [self.view addSubview:weiboBtn];
//    
//    [weiboBtn addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.right.equalTo(self.view.mas_right).offset(-60);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
//        make.width.equalTo(@50);
//        make.height.equalTo(@50);
//    }];
//    
////    weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
////    
////    [weixinBtn addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
////    
////    [self.view addSubview:weixinBtn];
////    
////    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        
////        @strongify(self);
////        make.centerX.equalTo(self.view);
////        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
////        make.width.equalTo(@50);
////        make.height.equalTo(@50);
////    }];
//    
//    thirdLoginLabel = [[UILabel alloc]init];
//    thirdLoginLabel.text = @"其他方式登录";
//    thirdLoginLabel.textColor = [UIColor darkGrayColor];
//    thirdLoginLabel.font = [UIFont systemFontOfSize:14];
//    thirdLoginLabel.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:thirdLoginLabel];
//    
//    [thirdLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.centerX.equalTo(self.view);
//        make.height.equalTo(@30);
//        make.bottom.equalTo(weixinBtn.mas_top).offset(-20);
//    }];
//    
//    line3View = [[UIView alloc]init];
//    line3View.backgroundColor = BGColor;
//    [self.view addSubview:line3View];
//    
//    [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.right.equalTo(thirdLoginLabel.mas_left).offset(-20);
//        make.height.equalTo(@1);
//        make.bottom.equalTo(weixinBtn.mas_top).offset(-35);
//    }];
//    
//    line4View = [[UIView alloc]init];
//    line4View.backgroundColor = BGColor;
//    [self.view addSubview:line4View];
//    
//    [line4View mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.left.equalTo(thirdLoginLabel.mas_right).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//        make.height.equalTo(@1);
//        make.bottom.equalTo(weixinBtn.mas_top).offset(-35);
//    }];
//  
}

#pragma mark -登陆
-(void)login:(id)sender{
    
    
//    [self showHint:@"登录成功"];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self presentViewController:[[MainViewController alloc] init] animated:NO completion:^{
////            [self.player stop];
////            [self.player.view removeFromSuperview];
////            self.player = nil;
//        }];
//    });


    
//    if (![BAIRUITECH_Utils isRightPhoneNum:phoneTextField.text  withCountry:@"+86"]) {
//        
//        [BAIRUITECH_BRTipView showTipTitle:@"手机号码格式不正确" delay:1];
//        return ;
//    }
    if (!(phoneTextField.text.length>0)) {
        [self showHint:@"请输入账号"];
        return;
    }
    if (!(passwordTextField.text.length>0)) {
        [self showHint:@"请输入密码"];
        return;
    }
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在登录中...";
    [HUD show:YES];
    
    NSDictionary *param = @{@"loginName":phoneTextField.text,@"loginPass":passwordTextField.text};
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_loginParam:param withSuccessBlock:^(NSDictionary *object) {
        
        if([object[@"ret"] intValue] == 0){
        
            YJLog(@"用户信息:%@",object);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
            [dic setObject:phoneTextField.text forKey:@"phone"];
            
            //将账户信息存到BRAccount工具类中
            BAIRUITECH_BRAccount * account = [[BAIRUITECH_BRAccount alloc] initWithDictionary:dic];
            [BAIRUITECH_BRAccoutTool saveAccount:account];
        
//            UIApplication *app = [UIApplication sharedApplication];
//            
//            AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
//            [delegate showTabViewController];
            // 执行动画
        
            [self setUpSocket];
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.block) {
                self.block();
            }
            //            CATransition *anim = [CATransition animation];
//            anim.duration = 0.4;
//            anim.type = kCATransitionPush;
//            anim.subtype = kCATransitionFromRight;
//            [app.keyWindow.layer addAnimation:anim forKey:nil];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self presentViewController:[[MainViewController alloc] init] animated:NO completion:^{
//                    //            [self.player stop];
//                    //            [self.player.view removeFromSuperview];
//                    //            self.player = nil;
//                }];
         
            
        }else{
        
            [self showHint:object[@"msg"]];
//            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
        [HUD hide:YES];
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
        [HUD hide:YES];
        
        [BAIRUITECH_BRTipView showTipTitle:@"连接异常，请检查网络或重试" delay:1.5];
    }];
    
}

- (void)setUpSocket{
    
    NSLog(@"setUpSocket");
    
    BAIRUITECH_BRAccount *userInfo = [BAIRUITECH_BRAccoutTool account];
    FabricSocket *socket = [FabricSocket shareInstances];
    socket.userId = userInfo.userId;
    socket.token = userInfo.token;
    socket.host = userInfo.chatAddress;
    [socket connect];
}

-(void)dealloc{

    YJLog(@"BRLoginViewController被释放");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   

    
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if (textField == passwordTextField) {
//        if (range.location < 12) {
//            return YES;
//        }else
//        {
//            return NO;
//        }
//    }
//    else if (textField == phoneTextField)
//    {
//        if (range.location >= 11) {
//            return NO;
//        }else
//        {
//            return YES;
//        }
//    }
    
    
    return YES;
    
}

#pragma mark - incident
- (void)change{
//    if (phoneTextField.text.length == 11 && passwordTextField.text.length) {
//        [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮"] forState:UIControlStateNormal];
//        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        loginButton.enabled = YES;
//    }else
//    {
//        [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录初始按钮"] forState:UIControlStateNormal];
//        [loginButton setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"c5c5c5"] forState:UIControlStateNormal];
//        loginButton.enabled = NO;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

-(MBProgressHUD*)getShareHUD
{
    if (BbHUD==nil) {
        BbHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        
    }
    [self.view.window addSubview:BbHUD];
    BbHUD.removeFromSuperViewOnHide = YES;
    BbHUD.opacity=0.8;
    BbHUD.labelText=@"";
    return BbHUD;
}

#pragma mark -微信登陆
-(void)weixinLogin:(id)sender{
//
//    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"response.thirdPlatformUserProfile = %@",response.thirdPlatformUserProfile);
//            NSLog(@"snsAccount = %@",snsAccount);
//            
//            NSString *sexStr = nil;
//            
//            if([response.thirdPlatformUserProfile[@"sex"] intValue] == 1){
//                
//                sexStr = @"1";
//                
//            }else{
//                
//                sexStr = @"0";
//            }
//            
//            
//            NSDictionary *param =@{@"openId":response.thirdPlatformUserProfile[@"openid"],
//                                   @"currentUserId":snsAccount.usid,
//                                   @"type":@"微信",
//                                   @"nickName":snsAccount.userName,
//                                   @"unionid":snsAccount.unionId,
//                                   @"photo":snsAccount.iconURL,
//                                   @"sex":sexStr,
//                                   @"clientid":delegate.clientId};
//            
//            NSLog(@"所需参数:%@",param);
//            
//            [BAIRUITECH_NetWorkManager FinanceLiveShow_thirdplatLoginParam:param withSuccessBlock:^(NSDictionary *object) {
//                
//                YJLog(@"%@",object);
//                if([object[@"errorCode"] intValue] == 0){
//                
//                    //将账户信息存到BRAccount工具类中
//                    BAIRUITECH_BRAccount * account = [[BAIRUITECH_BRAccount alloc] initWithDictionary:object[@"data"]];
//                    [BAIRUITECH_BRAccoutTool saveAccount:account];
//                    
//                    UIApplication *app = [UIApplication sharedApplication];
//                    
//                    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                    
//                    [delegate showTabViewController];
//                    // 执行动画
//                    
//                    CATransition *anim = [CATransition animation];
//                    anim.duration = 0.4;
//                    anim.type = kCATransitionPush;
//                    anim.subtype = kCATransitionFromRight;
//                    [app.keyWindow.layer addAnimation:anim forKey:nil];
//                }else{
//                
//                    [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
//                }
//                
//            } withFailureBlock:^(NSError *error) {
//                
//                YJLog(@"%@",error);
//            }];
//            
//            
//        }
//        
//    });
}
#pragma mark -QQ登陆
-(void)qqLoginClick:(id)sender {
    
//    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            NSLog(@"dict:%@",dict);
//            
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            
//            NSLog(@"snsAccount = %@",snsAccount);
//            NSLog(@"profile = %@",response.thirdPlatformUserProfile);
//            
//            NSLog(@"response :%@",snsAccount.openId);
//            
//            
//            NSString *sexStr = nil;
//            
//            if([response.thirdPlatformUserProfile[@"gender"] isEqual:@"男"]){
//                
//                sexStr = @"1";
//                
//            }else{
//                
//                sexStr = @"0";
//            }
//            
//            NSDictionary *param =@{@"openId":snsAccount.openId,
//                                   @"currentUserId":snsAccount.usid,
//                                   @"type":@"qq",
//                                   @"nickName":snsAccount.userName,
//                                   @"photo":snsAccount.iconURL,
//                                   @"sex":sexStr,
//                                   @"clientid":delegate.clientId};
//            
//            NSLog(@"所需参数:%@",param);
//            
//            [BAIRUITECH_NetWorkManager FinanceLiveShow_thirdplatLoginParam:param withSuccessBlock:^(NSDictionary *object) {
//                
//                YJLog(@"%@",object);
//                if([object[@"errorCode"] intValue] == 0){
//                    
//                    //将账户信息存到BRAccount工具类中
//                    BAIRUITECH_BRAccount * account = [[BAIRUITECH_BRAccount alloc] initWithDictionary:object[@"data"]];
//                    [BAIRUITECH_BRAccoutTool saveAccount:account];
//                    
//                    UIApplication *app = [UIApplication sharedApplication];
//                    
//                    AppDelegate* delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                    
//                    [delegate showTabViewController];
//                    // 执行动画
//                    
//                    CATransition *anim = [CATransition animation];
//                    anim.duration = 0.4;
//                    anim.type = kCATransitionPush;
//                    anim.subtype = kCATransitionFromRight;
//                    [app.keyWindow.layer addAnimation:anim forKey:nil];
//                }else{
//                    
//                    [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
//                }
//                
//            } withFailureBlock:^(NSError *error) {
//                
//                YJLog(@"%@",error);
//            }];
//            
//            
//        }});
}


#pragma mark -新浪微博登陆
- (void)sinaLogin:(id)sender {
    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//                  //获取微博用户名、uid、token等
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
//            
//        }});
}


@end
