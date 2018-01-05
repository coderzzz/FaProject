//
//  AreaCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AreaCell.h"

@implementation AreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lab.layer.masksToBounds = YES;
    self.lab.layer.borderWidth = 1;
    self.lab.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.lab.layer.cornerRadius = 4;
}

@end
