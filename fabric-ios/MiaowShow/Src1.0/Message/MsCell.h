//
//  MsCell.h
//  MiaowShow
//
//  Created by sam on 2017/9/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *sublab;

@property (weak, nonatomic) IBOutlet UIButton *arrowbtn;

@end
