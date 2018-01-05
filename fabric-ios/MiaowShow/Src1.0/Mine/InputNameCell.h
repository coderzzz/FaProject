//
//  InputNameCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputNameCell : UITableViewCell

@property(nonatomic, strong) UIButton *getTestCodeBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *titlab;

@property (weak, nonatomic) IBOutlet UITextField *tf;


@end
