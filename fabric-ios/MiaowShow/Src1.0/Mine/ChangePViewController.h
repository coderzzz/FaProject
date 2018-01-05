//
//  ChangePViewController.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePViewControllerDelegate <NSObject>

@optional

- (void)changePhone:(NSString *)phone code:(NSString *)code;

@end



@interface ChangePViewController : UIViewController

@property (nonatomic, weak) id<ChangePViewControllerDelegate>delegate;

@end
