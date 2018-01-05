//
//  ZZTagCell.m
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ZZTagCell.h"

@implementation ZZTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpColor{
    
    
}
- (void)setZZTag:(ZZTag *)tag{
    
    self.lab.text = tag.title;
    self.lab.layer.masksToBounds = YES;
    self.lab.layer.cornerRadius = 11;
    
    if (tag.selected) {
        self.lab.textColor =[UIColor whiteColor];
        self.lab.backgroundColor = tag.color;
        
    }else{
        
        self.lab.textColor =tag.color;
        self.lab.layer.borderWidth = 1;
        self.lab.layer.borderColor = tag.color.CGColor;
        self.lab.backgroundColor = [UIColor clearColor];
    }
}



@end
