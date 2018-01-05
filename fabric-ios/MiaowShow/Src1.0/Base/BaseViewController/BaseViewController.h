//
//  BaseViewController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, copy)void(^Login)();
-(BOOL)testLogin;

@end
