//
//  PopCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PopCell.h"

@implementation PopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imagv.layer.masksToBounds = YES;
    self.imagv.layer.cornerRadius = 35/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
