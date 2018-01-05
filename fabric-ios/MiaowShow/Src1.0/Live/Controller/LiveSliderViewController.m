//
//  LiveSliderViewController.m
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "LiveSliderViewController.h"

@interface LiveSliderViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LiveSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    CGPoint point =[touch locationInView:self.toolView];
    if (point.y >0) {
        
        return NO;
    }
    return YES;
}


- (IBAction)aciton:(UIButton *)sender {
    if (self.didSelect) {
        self.didSelect(sender);
    }
}
@end
