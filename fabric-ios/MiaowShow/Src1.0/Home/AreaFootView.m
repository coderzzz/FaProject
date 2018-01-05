//
//  AreaFootView.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AreaFootView.h"

@implementation AreaFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)reset:(id)sender {
    
    if (self.Action) {
        self.Action(0);
    }
}
- (IBAction)done:(id)sender {
    
    if (self.Action) {
        self.Action(1);
    }
    
}

@end
