//
//  OrderMsgCell.h
//  Farbic
//
//  Created by sam on 2018/1/7.
//  Copyright © 2018年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contenV;
@property (weak, nonatomic) IBOutlet UILabel *datelab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
