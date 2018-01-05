//
//  FansCell.m
//  MiaowShow
//
//  Created by sam on 2017/9/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imagV.layer.masksToBounds = YES;
    self.imagV.layer.cornerRadius = 15;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
