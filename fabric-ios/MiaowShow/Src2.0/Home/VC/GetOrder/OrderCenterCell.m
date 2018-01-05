//
//  OrderCenterCell.m
//  Farbic
//
//  Created by bairuitech on 2017/12/7.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "OrderCenterCell.h"


@interface OrderCenterCell()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet ZZImageView *imageScrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet ZZTagView *tagView;


@end

@implementation OrderCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 16;
//    self.collectV.hidden = YES;
}

- (void)setDic:(NSDictionary *)dic{
    
    _dic = dic;
    
    NSString *userlogo = [NSString stringWithFormat:@"%@%@",ImageURL,dic[@"userLogo"]];
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:userlogo
                                      ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]] ;
    self.nameLab.text = dic[@"nickName"];
    self.dateLab.text = [NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@",dic[@"createdTime"]]];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",dic[@"goodsAmt"]];
    
    NSArray *imgs = [dic[@"imgUrl"] componentsSeparatedByString:@","];
    NSMutableArray *imagary = [NSMutableArray array];
    for (NSString *str in imgs) {
        
        ZZItem *tag = [ZZItem new];
        tag.imageUrl = str;
        [imagary addObject:tag];
    }
    self.imageScrollView.list = imagary;
    self.titleLab.text = dic[@"goodsName"];
    self.detailLab.text = dic[@"descriptions"];
    
//    cell.nameLab.text = dic[@"custName"];
//    [cell.objImgv sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] placeholderImage:nil];
//    cell.objTitle.text = dic[@"goodsName"];
//    cell.objDetail.text = dic[@"descriptions"];
    NSArray *marks = [dic[@"marks"] componentsSeparatedByString:@","];
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *mark in marks) {
        
        ZZTag *tag = [ZZTag new];
        tag.title = mark;
        tag.color = Color;
        tag.height=24;
        [tags addObject:tag];
    }
    self.tagView.list = tags;
}


- (IBAction)getOrder:(id)sender {
   
    if (self.Click) {
        self.Click();
    }
}





@end
