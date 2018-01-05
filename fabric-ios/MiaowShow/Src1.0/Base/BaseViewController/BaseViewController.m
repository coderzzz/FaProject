//
//  BaseViewController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
}

- (BOOL)isLogin{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    if ([user.userId isEqualToString:@"0"]) {
        
        return NO;
    }
    return YES;
}

- (void)showLogin{
    
    BRLoginViewController *vc = [BRLoginViewController new];
    [vc setBlock:^(void){
        
        if (self.Login) {
            self.Login();
        }
    }];
    
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}


-(BOOL)testLogin{
    
    if (![self isLogin]) {
        
        [self showLogin];
        return NO;
    }
    return YES;
}
@end
