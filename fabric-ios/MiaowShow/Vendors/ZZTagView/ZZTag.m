//
//  ZZTag.m
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ZZTag.h"

@implementation ZZTag

-(CGSize)sizes{
    
    return [[self class]dc_calculateTextSizeWithText:self.title WithMaxW:self.height];
}

+ (CGSize)dc_calculateTextSizeWithText : (NSString *)text  WithMaxW : (CGFloat)maxH {

    CGSize textMaxSize = CGSizeMake(MAXFLOAT, maxH);
    
    CGSize textSize = [text boundingRectWithSize:textMaxSize options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    if (textSize.width <20) {
        textSize.width = 20;
    }
    textSize.width = textSize.width + 20;
//    CGSize size = CGSizeMake(textSize.width , <#CGFloat height#>)
    return textSize;
}

@end
