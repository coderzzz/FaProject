//
//  MainHeadViewCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/9/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeadViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImgv;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;

@property (copy, nonatomic) void(^BtnAction)(NSInteger tag);

@end
