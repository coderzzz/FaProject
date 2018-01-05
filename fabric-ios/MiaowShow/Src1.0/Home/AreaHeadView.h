//
//  AreaHeadView.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (copy, nonatomic) void(^Click)(void);
@end
