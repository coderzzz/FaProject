//
//  MsgTableViewCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/8/30.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFLabel.h"
@interface MsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet SFLabel *contenLab;
+ (CGSize)sizeToLabelWidthWithStr:(NSString *)str;

- (void)setString:(NSString *)str userName:(NSString *)userName;
@end
