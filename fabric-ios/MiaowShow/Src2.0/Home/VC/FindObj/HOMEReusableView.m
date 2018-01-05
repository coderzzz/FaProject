//
//  HOMEReusableView.m
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "HOMEReusableView.h"

#import <SDCycleScrollView.h>
// Categories

// Others

@interface HOMEReusableView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;


@end

@implementation HOMEReusableView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"HOMEReusableView" owner:self options:nil]firstObject];
        
    }
    return self;
}


#pragma mark - 布局
- (void)getList:(NSArray *)list{
    
    _adList = [list copy];
    
    NSMutableArray *list1 = [NSMutableArray array];
    for (NSDictionary *ad in _adList) {
        
        NSString *url = [NSString stringWithFormat:@"%@",ad[@"pictureUrl"]];
        if (url.length>0) {
            [list1 addObject:url];
        }
    }
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) delegate:self placeholderImage:[UIImage imageNamed:@"112"]];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        
        
        [self addSubview:_cycleScrollView];
    }
    _cycleScrollView.imageURLStringsGroup = list1;
}
- (void)setAdList:(NSArray *)adList{
    
    _adList = adList;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *ad in adList) {
        
        NSString *url = [NSString stringWithFormat:@"%@",ad[@"pictureUrl"]];
        if (url.length>0) {
            [list addObject:url];
        }
    }
    if (!_cycleScrollView) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3) delegate:self placeholderImage:[UIImage imageNamed:@"112"]];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 3.0;
        
        
        [self addSubview:_cycleScrollView];
    }
    _cycleScrollView.imageURLStringsGroup = list;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    
    if (index<_adList.count) {
        
        NSDictionary *dic = (NSDictionary *)_adList[index];
        if (dic  && self.Click) {
            
            self.Click(dic);
        }
        
    }
    
    
}


@end
