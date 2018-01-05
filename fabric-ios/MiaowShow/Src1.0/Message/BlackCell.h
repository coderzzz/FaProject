//
//  BlackCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/9/27.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *sublab;
@property (copy, nonatomic) void(^click)(void);
@end
