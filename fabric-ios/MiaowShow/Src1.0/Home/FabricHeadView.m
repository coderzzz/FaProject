//
//  DCCountDownHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "FabricHeadView.h"

// Controllers

// Models

// Views

// Vendors
#import <SDCycleScrollView.h>
// Categories

// Others

@interface FabricHeadView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIView *ScrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;


@end

@implementation FabricHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"FabricHeadView" owner:self options:nil]firstObject];
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = BGColor;
    self.leftLab.textColor = MainColor;
    
    self.head.layer.masksToBounds = YES;
    self.head.layer.cornerRadius = 15;
    
    
    
    
//    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 164) delegate:self placeholderImage:[UIImage imageNamed:@"112"]];
//    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    _cycleScrollView.autoScrollTimeInterval = 3.0;
//    _cycleScrollView.imageURLStringsGroup = list;
//    
//    [self.ScrollContentView addSubview:_cycleScrollView];
}
#pragma mark - 布局

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
        
        
        [self.ScrollContentView addSubview:_cycleScrollView];
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

#pragma mark - Setter Getter Methods


@end
