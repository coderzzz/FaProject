//
//  DelFOController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/21.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "DelFOController.h"

@interface DelFOController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation DelFOController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];

}


- (IBAction)done:(id)sender {
    
    [self doneOR:YES];
    
}

- (void)doneOR:(BOOL)done{
    
    [self showHudInView:self.view];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_delGO:@{@"askId":_dic[@"askId"]} withSuccessBlock:^(NSDictionary *object) {
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            

            [self close:nil];
            if (self.del) {
                self.del();
            }
        }else{
            
            //                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        YJLog(@"%@",error);
        
    }];
}



-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}

- (IBAction)close:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}


@end
