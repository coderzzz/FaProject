//
//  MainHeadViewCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MainHeadViewCell.h"

@implementation MainHeadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgv.layer.masksToBounds = YES;
    self.headImgv.layer.cornerRadius = 45/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)action:(UIButton *)sender {
    
    if (self.BtnAction) {
        
        self.BtnAction(sender.tag);
    }
}

@end
