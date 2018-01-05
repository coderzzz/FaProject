//
//  InputViewController.m
//  igame
//
//  Created by Interest on 2016/12/14.
//  Copyright © 2016年 Interest. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UIButton *donebtn;
@property (weak, nonatomic) IBOutlet UIView *topview;

@end

@implementation InputViewController
{
    NSMutableArray *list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tf becomeFirstResponder];

    self.title = @"交易密码";
    list = [@[_lab1,_lab2,_lab3,_lab4]mutableCopy];

}

- (IBAction)activetf:(id)sender {
    
    if (![self.tf isFirstResponder]) [self.tf becomeFirstResponder];
}

- (IBAction)done:(id)sender {
    
    if (self.tf.text.length == 4) {
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 4 && string.length) {
        
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        totalString = [textField.text substringToIndex:textField.text.length-1];
    }
    else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    for (int a =0; a<list.count; a++) {
        
        UILabel *lab = list[a];
        if (a<totalString.length) {
            
            lab.text = [totalString substringWithRange:NSMakeRange(a, 1)];
        }else{
            lab.text = @"";
        }
        
    }
    NSLog(@"_____total %@",totalString);
    return YES;
}

@end
