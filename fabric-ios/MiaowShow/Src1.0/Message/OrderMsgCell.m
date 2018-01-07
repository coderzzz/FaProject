//
//  OrderMsgCell.m
//  Farbic
//
//  Created by sam on 2018/1/7.
//  Copyright © 2018年 ALin. All rights reserved.
//

#import "OrderMsgCell.h"

@implementation OrderMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contenV cornerRadius:5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
