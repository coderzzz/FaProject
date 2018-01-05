//
//  UpCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "UpCell.h"

@implementation UpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)action:(id)sender {
    
    if (self.Click) {
        self.Click();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
