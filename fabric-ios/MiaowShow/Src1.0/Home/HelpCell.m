//
//  HelpCell.m
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "HelpCell.h"

@implementation HelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.head.layer.masksToBounds = YES;
    self.head.layer.cornerRadius = 10;
}

@end
