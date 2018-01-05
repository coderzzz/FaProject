//
//  DCCountDownHeadView.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabricHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIButton *morebtn;
@property (weak, nonatomic) IBOutlet UIButton *head;
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UILabel *sublab;
@property (weak, nonatomic) IBOutlet UIButton *rightbtn;

@property (copy, nonatomic) NSArray *adList;
@property (copy, nonatomic) void (^Click)(NSDictionary *dic);
@end
