//
//  SliderViewController.h
//  MiaowShow
//
//  Created by sam on 2017/10/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController

@property (nonatomic, copy)NSArray *data;
@property (nonatomic, copy) void (^didSelect)(NSInteger index);
@property (copy, nonatomic) void(^hideBlock)();
@end
