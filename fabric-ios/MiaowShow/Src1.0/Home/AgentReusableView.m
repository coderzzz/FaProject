//
//  AgentReusableView.m
//  MiaowShow
//
//  Created by sam on 2017/9/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AgentReusableView.h"



@implementation AgentReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"AgentReusableView" owner:self options:nil]firstObject];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contan.height) delegate:self placeholderImage:nil];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        _cycleScrollView.imageURLStringsGroup = @[@"112",@"112",@"112"];
        
        [self.contan addSubview:_cycleScrollView];
    }
    return self;
}


- (void)setList:(NSArray *)list{
    
    _list = list;
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        
        [imgs addObject:dic[@"imgPath"]];
    }
    _cycleScrollView.imageURLStringsGroup =imgs;
}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    NSDictionary *dic = _list[index];
    if (self.block) {
        
        self.block(dic);
    }
    
}

@end
