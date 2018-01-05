//
//  MsHeadCell.m
//  MiaowShow
//
//  Created by sam on 2017/9/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MsHeadCell.h"

@implementation MsHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
