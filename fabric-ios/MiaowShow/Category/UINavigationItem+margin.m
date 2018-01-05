//
//  UINavigationItem+margin.m
//  AnyChatInterview
//
//  Created by bairuitech on 2017/3/31.
//  Copyright © 2017年 anychat. All rights reserved.
//

#import "UINavigationItem+margin.h"

@implementation UINavigationItem (margin)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -5;
    
    if (_leftBarButtonItem)
    {
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
    }
    else
    {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
    
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -5;
    
    if (_rightBarButtonItem)
    {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
    }
    else
    {
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
   
}
@end
