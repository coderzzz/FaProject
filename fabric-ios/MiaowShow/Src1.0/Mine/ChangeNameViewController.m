//
//  ChangeNameViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.btn.backgroundColor = MainColor;
}
- (IBAction)done:(id)sender {
    
    if (self.tf.text.length>0) {
        
        [self.delegate changeName:self.tf.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
