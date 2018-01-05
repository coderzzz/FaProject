//
//  UpObjImageController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface UpObjImageController : BaseViewController
@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, copy) void(^UpSuccess)();
-(void)show;
@end
