//
//  OrderCenterCell.h
//  Farbic
//
//  Created by bairuitech on 2017/12/7.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCenterCell : UITableViewCell
@property (nonatomic, copy) NSDictionary *dic;
@property(nonatomic, copy) void(^Click)();
@end
