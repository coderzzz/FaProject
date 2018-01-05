//
//  ChangeNameViewController.h
//  MiaowShow
//
//  Created by bairuitech on 2017/9/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeNameDelegate <NSObject>

- (void)changeName:(NSString *)conten;

@end

@interface ChangeNameViewController : UIViewController
@property (weak, nonatomic) id<ChangeNameDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
