//
//  ZZTag.h
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTag : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *color;
@property (nonatomic, assign) CGSize sizes;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL selected;
+ (CGSize)dc_calculateTextSizeWithText : (NSString *)text  WithMaxW : (CGFloat)maxH;
@end
