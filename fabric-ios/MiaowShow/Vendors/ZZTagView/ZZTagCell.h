//
//  ZZTagCell.h
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTag.h"
@interface ZZTagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab;


- (void)setZZTag:(ZZTag *)tag;
@end
