//
//  CameraTypeController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface CameraTypeController : BaseViewController

@property (nonatomic, copy) void (^didSelect)(NSInteger index);

@end
