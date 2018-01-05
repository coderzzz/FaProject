//
//  AgentReusableView.h
//  MiaowShow
//
//  Created by sam on 2017/9/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
typedef void (^Block)(NSDictionary *dic);
@interface AgentReusableView : UICollectionReusableView<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (weak, nonatomic) IBOutlet UIView *contan;

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;
@property (strong,nonatomic) NSArray *list;
@property (weak, nonatomic) IBOutlet UILabel *caName;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic, copy) Block block;

@end
