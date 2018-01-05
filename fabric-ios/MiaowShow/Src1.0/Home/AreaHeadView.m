//
//  AreaHeadView.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AreaHeadView.h"

@implementation AreaHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lab.textColor = MainColor;
}
- (IBAction)action:(id)sender {
    
    if (self.Click) {
        self.Click();
    }
}

@end
