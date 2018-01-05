//
//  UpCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpCell : UITableViewCell

@property (copy, nonatomic) void(^Click)();

@property (weak, nonatomic) IBOutlet UIButton *btn;
@end
