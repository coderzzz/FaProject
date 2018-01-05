//
//  SexViewController.h
//  MiaowShow
//
//  Created by bairuitech on 2017/9/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SexDelegate <NSObject>

- (void)changeSex:(NSString *)conten;

@end
@interface SexViewController : UIViewController
@property (weak, nonatomic) id<SexDelegate>delegate;
@end
