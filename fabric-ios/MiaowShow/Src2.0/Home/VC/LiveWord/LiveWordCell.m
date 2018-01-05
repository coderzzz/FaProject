//
//  LiveWordCell.m
//  Farbic
//
//  Created by bairuitech on 2017/12/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "LiveWordCell.h"

@implementation LiveWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
