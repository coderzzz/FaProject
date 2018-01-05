//
//  DelFOController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/21.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface DelFOController : BaseViewController
@property (nonatomic, copy) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, copy) void(^del)();
-(void)show;
@end
