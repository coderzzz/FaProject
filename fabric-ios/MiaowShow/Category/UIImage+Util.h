//
//  UIImage+Util.h

//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
+ (UIImage *)imageFromView:(UIView *)view;
- (UIImage *)imageWithScale:(CGFloat)scale;
- (UIImage *)imageWithSize:(CGSize)size;
- (NSString *)encodeBase64;
@end
