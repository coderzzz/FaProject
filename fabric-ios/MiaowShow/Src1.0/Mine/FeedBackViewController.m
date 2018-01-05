//
//  FeedBackViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;




@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self enAbleBtn:NO];

//    self.phoneTF.delegate = self;
}
- (IBAction)feedBack:(id)sender {
    
    [self showHudInView:self.view];
    
  
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_feedBack:@{@"feedbackContent":self.textView.text,@"contact":self.phoneTF.text,@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}

- (void)updateBtn{
    
    if (self.textView.text.length>0 && self.phoneTF.text.length>0) {
        
        [self enAbleBtn:YES];
    }else{
        
        [self enAbleBtn:NO];
    }
}

- (void)enAbleBtn:(BOOL)state{
    
    self.uploadBtn.userInteractionEnabled = state;
    self.uploadBtn.selected = state;
}


#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    [self updateBtn];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self updateBtn];
    return YES;
}

@end
