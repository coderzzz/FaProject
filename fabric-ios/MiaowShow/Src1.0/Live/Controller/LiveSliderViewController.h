//
//  LiveSliderViewController.h
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveSliderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (nonatomic, copy) void (^didSelect)(UIButton *btn);
@property (copy, nonatomic) void(^hideBlock)();


- (IBAction)aciton:(UIButton *)sender;

@end
