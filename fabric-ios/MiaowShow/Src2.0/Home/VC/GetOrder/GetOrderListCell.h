//
//  GetOrderListCell.h
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetOrderListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet ZZTagView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgv;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *objImgv;
@property (weak, nonatomic) IBOutlet UILabel *objTitle;
@property (weak, nonatomic) IBOutlet UILabel *objDetail;
@property (weak, nonatomic) IBOutlet UILabel *allPirce;
@property (weak, nonatomic) IBOutlet ZZTagView *actionTag;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *statueLab;
@property (weak, nonatomic) IBOutlet UILabel *ctLab;
@property (weak, nonatomic) IBOutlet UILabel *gtLab;

@property (copy, nonatomic) void(^Chat)();

@end
