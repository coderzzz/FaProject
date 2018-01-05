//
//  GetOrderListCell.m
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GetOrderListCell.h"

@implementation GetOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)lookFinder:(id)sender {
    if (self.Chat) {
        self.Chat();
    }
}

@end
