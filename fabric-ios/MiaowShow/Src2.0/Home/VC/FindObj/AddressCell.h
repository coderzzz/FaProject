//
//  AddressCell.h
//  Farbic
//
//  Created by sam on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (copy, nonatomic) void(^Click)(NSInteger tag);

@property (copy, nonatomic) NSDictionary *dic;

@end
