//
//  SliderCell.m
//  MiaowShow
//
//  Created by sam on 2017/10/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SliderCell.h"

@implementation SliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
