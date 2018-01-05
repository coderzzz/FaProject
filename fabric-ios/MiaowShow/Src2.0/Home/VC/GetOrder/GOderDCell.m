//
//  GOderDCell.m
//  Farbic
//
//  Created by bairuitech on 2017/12/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GOderDCell.h"

@implementation GOderDCell

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
