//
//  ZZImageView.h
//  Farbic
//
//  Created by bairuitech on 2017/12/13.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZItem.h"
@interface ZZImageView : UIView

@property (nonatomic, copy) NSMutableArray *list;
@property (nonatomic, copy) void(^DeleteItem)(ZZItem *item);
@property (nonatomic, assign) BOOL canDel;
- (void)addTag:(ZZItem *)item;
- (void)removeTag:(ZZItem *)item;
@end
