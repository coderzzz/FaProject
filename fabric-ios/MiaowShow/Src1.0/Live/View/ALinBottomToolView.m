//
//  ALinBottomToolView.m
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinBottomToolView.h"

@implementation ALinBottomToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (NSArray *)tools
{
    return @[@"私信", @"分享", @"购物", @"礼物", @"更多"];
}

- (void)setup
{
    CGFloat wh = 35;
    CGFloat margin = 6;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i<self.tools.count; i++) {
        x = margin + (margin + wh) * i;
        UIImageView *toolView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
        toolView.userInteractionEnabled = YES;
        toolView.tag = i;
        toolView.image = [UIImage imageNamed:self.tools[i]];
        [toolView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self addSubview:toolView];
    }
}

- (void)click:(UITapGestureRecognizer *)tapRec
{
    if (self.clickToolBlock) {
        self.clickToolBlock(tapRec.view.tag);
    }
}
@end
