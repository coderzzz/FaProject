//
//  CameraTypeController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "CameraTypeController.h"

@interface CameraTypeController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CameraTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}
- (IBAction)action:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (self.didSelect) {
        self.didSelect(btn.tag);
    }
    [self hide];
}

- (void)hide{
    
    self.view.hidden = YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point =[touch locationInView:self.contentView];
    
    NSLog(@"y = %f",point.y);
    if (point.y >0 && point.y < 130) {
        
        return NO;
    }
    return YES;
}


@end
