//
//  InputNameCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "InputNameCell.h"

@implementation InputNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //获取验证码
    _getTestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getTestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _getTestCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _getTestCodeBtn.backgroundColor = MainColor;
    [self addSubview:_getTestCodeBtn];
    
    [_getTestCodeBtn bk_whenTapped:^{
        
        if (_tf.text.length != 11) {
            return ;
        }else{
            
            
            NSDictionary *param = @{@"mobile":_tf.text,@"type":@"3"};
            
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
    
    [_getTestCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        
    }];
}
- (void)startCntTime{
    static int time=0;
    time++;
    _getTestCodeBtn.userInteractionEnabled=NO;
    _getTestCodeBtn.alpha = 0.6;
//    [_getTestCodeBtn setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"cccccc"] forState:0];
    _getTestCodeBtn.titleLabel.text = [NSString stringWithFormat:@"(%d)重新获取",60-time];
    [_getTestCodeBtn setTitle:[NSString stringWithFormat:@"(%d)重新获取",60-time] forState:UIControlStateNormal];
    _getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (time == 60) {
        _getTestCodeBtn.userInteractionEnabled=YES;
        _getTestCodeBtn.alpha=1;
        [_getTestCodeBtn setTitleColor:[UIColor whiteColor] forState:0];
        time=0;
        [_getTestCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
        _getTestCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
