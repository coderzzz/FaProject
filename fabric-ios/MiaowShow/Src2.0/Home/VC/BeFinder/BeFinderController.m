//
//  BeFinderController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BeFinderController.h"
#import "WYGenderPickerView.h"
#define validCodeTime 60
@interface BeFinderController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet ZZTagView *tagView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *wordTF;
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *selectlist;
@end

@implementation BeFinderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成为找样人";
    
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 486);
    
    self.tagView.layer.masksToBounds = YES;
    self.tagView.layer.cornerRadius = 5;
    [self.scrollView addSubview:self.contentView];
    [self loadDatas];
    [self.tagView setDidSelect:^(ZZTag *tag){
        
        if ([_selectlist containsObject:tag.title]) {
            tag.selected = NO;
            [_selectlist removeObject:tag.title];
        }else{
            
            tag.selected = YES;
            [_selectlist addObject:tag.title];
        }
        [self.tagView.collectionView reloadData];
        self.typeLab.text = [_selectlist componentsJoinedByString:@","];
    }];
    
}
- (void)loadDatas{
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_tags:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            self.list = [NSMutableArray array];
            self.selectlist = [NSMutableArray array];
            NSArray *temp= object[@"data"];
            for (NSDictionary *dic in temp) {
                
                ZZTag *tag = [ZZTag new];
                tag.color = Color;
                tag.title= dic[@"name"];
                tag.height= 27;
                [self.list addObject:tag];
            }
            self.tagView.list = self.list;
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    
}
- (IBAction)sex:(id)sender {
    
    WYGenderPickerView *genderPickerView = [[WYGenderPickerView alloc] initWithInitialGender:_sexBtn.titleLabel.text];
    
    genderPickerView.confirmBlock = ^(NSString *selectedGender) {

        _sexBtn.titleLabel.text = selectedGender;
        
    };
    
    [self.view addSubview:genderPickerView];
    
}
- (IBAction)showTypes:(id)sender {
}
- (IBAction)getWord:(id)sender {
    
    if (_phoneTF.text.length != 11) {
        return ;
    }else{
        
        
        NSDictionary *param = @{@"mobile":_phoneTF.text,@"type":@"3"};
        
        [BAIRUITECH_NetWorkManager FinanceLiveShow_SMSCodeParam:param withSuccessBlock:^(NSDictionary *object) {
            
            YJLog(@"验证码%@",object);
             [self showHint:object[@"msg"]];
            if([object[@"ret"]intValue] == 0){
                
                
               
                
                //                    [BAIRUITECH_BRTipView showTipTitle:@"验证码发送成功，请注意查收" delay:1];
                
                _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCntTime) userInfo:nil repeats:YES];
                [_timer fire];
                
                //                    testCodeTextField.text = [NSString stringWithFormat:@"%@",object[@"data"][@"mobileCode"]];
                
            }else{
                
//                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
            }
            
            
        } withFailureBlock:^(NSError *error) {
            
            
            YJLog(@"error %@",error);
            
            
        }];
        
    }

    
}
- (void)startCntTime{
    static int time=0;
    time++;
    _wordBtn.userInteractionEnabled=NO;
    _wordBtn.alpha = 0.6;
    //    [getTestCodeBtn setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"cccccc"] forState:0];
    _wordBtn.titleLabel.text = [NSString stringWithFormat:@"(%d)重新获取",validCodeTime-time];
    [_wordBtn setTitle:[NSString stringWithFormat:@"(%d)重新获取",validCodeTime-time] forState:UIControlStateNormal];
    _wordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    if (time == validCodeTime) {
        _wordBtn.userInteractionEnabled=YES;
        _wordBtn.alpha=1;
        [_wordBtn setTitleColor:[UIColor whiteColor] forState:0];
        time=0;
        [_wordBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
        _wordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_timer invalidate];
        _timer=nil;
    }
}

- (IBAction)up:(id)sender {
    
    if (!(self.nameTF.text.length>0)) {
        
        [self showHint:@"请输入姓名"];
        return;
    }
    if (!(_typeLab.text.length>0)) {
        
        [self showHint:@"请选择类型"];
        return;
    }
    
    if (!(self.phoneTF.text.length>0)) {
        
        [self showHint:@"请输入手机号码"];
        return;
    }

    if (!(self.wordTF.text.length>0)) {
        
        [self showHint:@"请输入验证码"];
        return;
    }
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    NSString *sex = [self.sexBtn.currentTitle isEqualToString:@"男"]?@"M":@"W";
    [BAIRUITECH_NetWorkManager FinanceLiveShow_beF:@{@"personName":_nameTF.text,@"custId":account.userId,@"sex":sex,@"mainBusiness":_typeLab.text,@"telephone":_phoneTF.text,@"verifyCode":_wordTF.text} withSuccessBlock:^(NSDictionary *object) {
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            //                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        YJLog(@"%@",error);
        
    }];

    
}




@end
