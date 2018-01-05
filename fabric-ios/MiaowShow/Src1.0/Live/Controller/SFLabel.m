//
//  SFSFEssenceLabel.m
//  百思不得姐
//
//  Created by 樊帅飞 on 16/6/27.
//  Copyright © 2016年 nowGO. All rights reserved.
//

#import "SFLabel.h"
#import <UIKit/UIKit.h>

@interface SFLabel ()

#define Width 10

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation SFLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.edgeInsets = UIEdgeInsetsMake(0, Width, 0, Width);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.edgeInsets = UIEdgeInsetsMake(0, Width, 0, Width);
    }
    return self;
}

- (void)awakeFromNib
{
    self.edgeInsets = UIEdgeInsetsMake(0, Width, 0, Width);
}

+ (UIEdgeInsets)edgeInsets
{
    /*- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary<NSString *, id> *)attributes context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 7_0);
     方法计算label的大小时，由于不会调用textRectForBounds方法，并不会计算自己通过edgeInsets插入的内边距，而是实际的大小，因此手动返回进行修正*/
    return UIEdgeInsetsMake(0, Width, 0, Width);
}


+ (NSDictionary *)textLabelArrtibute
{
//    可以通过 NSMutableParagraphStyle修改左边内边距
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;//行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;
    attribute[NSParagraphStyleAttributeName] = paragraphStyle;
    return attribute;
}


#pragma mark 设置第一行和最后一行距离label的距离
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    //注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{

    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
