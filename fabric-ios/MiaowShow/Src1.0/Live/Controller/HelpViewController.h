//
//  HelpViewController.h
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property (copy, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (copy, nonatomic) void(^next)(NSDictionary *dic);
@property (copy, nonatomic) void(^hideBlock)();
@end
