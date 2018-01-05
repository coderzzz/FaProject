//
//  UIView+Tool.h
//  AnyChatInterview
//
//  Created by bairuitech on 2017/3/23.
//  Copyright © 2017年 anychat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tool)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

- (void)cornerRadius:(CGFloat )radius;

- (void)borderColor:(UIColor *)color;

@end
