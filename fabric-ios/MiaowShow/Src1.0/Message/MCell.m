//
//  MsCell.m
//  MiaowShow
//
//  Created by sam on 2017/9/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MCell.h"

@implementation MCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.logo.layer.masksToBounds = YES;
    self.logo.layer.cornerRadius = 45/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
