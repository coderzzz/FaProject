//
//  BlackCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/27.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BlackCell.h"

@implementation BlackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)remove:(id)sender {
    if (self.click) {
        self.click();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
