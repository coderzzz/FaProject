//
//  BRLoginViewController.h
//  HaoLive
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 bairuitech. All rights reserved.
//

#import "BRBaseViewController.h"

typedef void(^Completed)(void);

@interface BRLoginViewController : BRBaseViewController

@property (nonatomic,strong) UITextField *phoneTextField;   //手机号码输入框

@property (nonatomic,strong) UITextField *passwordTextField;//密码输入框

@property (nonatomic, copy) Completed block;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
