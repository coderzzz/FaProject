//
//  MallDeatilViewController.m
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MallDeatilViewController.h"

@interface MallDeatilViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MallDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.line.backgroundColor = MainColor;
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}


- (void)hide{
    
    if (self.hideBlock) {
        self.hideBlock();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point =[touch locationInView:self.mainView];
    if (point.y >0) {
        
        return NO;
    }
    return YES;
}
@end
