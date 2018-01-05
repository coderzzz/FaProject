//
//  AreaViewController.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaViewController : UIViewController
@property (nonatomic, copy) void(^ClickArea)(NSString *areaId);
@property (strong , nonatomic)NSMutableArray *gridItem;
@end
