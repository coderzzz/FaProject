//
//  HomeReusableView.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "HomeReusableView.h"

@implementation HomeReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"HomeResableView" owner:self options:nil]firstObject];
        
    
    }
    return self;
}

- (IBAction)more:(id)sender {
}

@end
