//
//  SysMsgCell.m
//  Farbic
//
//  Created by sam on 2018/1/7.
//  Copyright © 2018年 ALin. All rights reserved.
//

#import "SysMsgCell.h"

@implementation SysMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
