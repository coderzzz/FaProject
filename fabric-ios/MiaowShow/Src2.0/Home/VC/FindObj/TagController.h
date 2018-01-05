//
//  TagController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface TagController : BaseViewController
@property (nonatomic, copy) void(^ClickTag)(NSString *name,NSString *tagId);
@property (strong , nonatomic)NSMutableArray *gridItem;
@end
