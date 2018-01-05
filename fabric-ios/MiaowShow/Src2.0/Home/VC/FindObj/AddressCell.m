//
//  AddressCell.m
//  Farbic
//
//  Created by sam on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)action:(UIButton *)sender {
    
    if (self.Click) {
        self.Click(sender.tag);
    }
}

- (void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",dic[@"buyer"]];
    self.phoneLab.text = [NSString stringWithFormat:@"%@",dic[@"phone"]];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",dic[@"countryName"],dic[@"provinceName"],dic[@"cityName"],dic[@"areaName"],dic[@"address"]];
    self.defaultBtn.selected = [dic[@"isMr"] isEqualToString:@"Y"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
