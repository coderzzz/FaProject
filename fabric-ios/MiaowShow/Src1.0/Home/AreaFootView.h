//
//  AreaFootView.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaFootView : UICollectionReusableView

@property (copy, nonatomic) void(^Action)(NSInteger tag);
@end
