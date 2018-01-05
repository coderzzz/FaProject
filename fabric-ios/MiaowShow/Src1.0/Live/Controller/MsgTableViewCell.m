//
//  MsgTableViewCell.m
//  MiaowShow
//
//  Created by bairuitech on 2017/8/30.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MsgTableViewCell.h"

@implementation MsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contenLab.backgroundColor = [UIColor colorWithWhite:.2 alpha:.4];
    self.contenLab.layer.masksToBounds = YES;
    self.contenLab.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setString:(NSString *)str userName:(NSString *)userName{
    
    
    NSString *title = [NSString stringWithFormat:@"%@: %@",userName,str];
    CGSize size = [[self class] sizeToLabelWidthWithStr:title];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:title];
    [attstr addAttribute:NSForegroundColorAttributeName
                   value:MainColor
                   range:NSMakeRange(0, userName.length+1)];
//    self.contenLab.frame = CGRectMake(0, 5, size.width, size.height +10);
    self.contenLab.attributedText = attstr;
    if (size.height<20) {
        
        self.contenLab.frame = CGRectMake(0, 5, size.width +20, 30);
    }else{
        
        self.contenLab.frame = CGRectMake(0, 5, SCREEN_WIDTH/2 +10, size.height);
    }
    
}



+ (CGSize)sizeToLabelWidthWithStr:(NSString *)str{

     NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
     attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];

     CGSize size =  [str boundingRectWithSize:CGSizeMake(MAXFLOAT,21) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    if (size.width >= SCREEN_WIDTH/2) {
        
         CGSize size =  [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        return size;
    }
    else{
        
        return size;
    }
  
}

// - (void)sizeToLabelHeight
// {
//  
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    55     label.textColor = [UIColor whiteColor];
//    56     label.font = [UIFont systemFontOfSize:13];
//    57     label.numberOfLines = 0;//这个属性 一定要设置为0   0表示自动换行   默认是1 不换行
//    58     label.backgroundColor = [UIColor blackColor];
//    59     label.textAlignment = NSTextAlignmentLeft;
//    60
//    61     NSString *str = @"fsdfsfnksdfjsdkhfjksdhfjdolfsdfsfnksdfjsdkhfjksdhfjsdkhfjksdhfjdojdol";
//    62
//    63     //第一种方式
//    64     //    CGSize size = [str sizeWithFont:label.font constrainedToSize: CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    65
//    66     //第二种方式
//    67     NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    68     attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//    69
//    70     CGSize size =  [str boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    71     
//    72     label.frame = CGRectMake(100, 100, 100, size.height);
//    73     label.text = str;
//    74     
//    75     [self.view addSubview:label];
//    76 }
@end
