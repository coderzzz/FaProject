//
//  FabricLiveCell.h
//  MiaowShow
//
//  Created by bairuitech on 2017/8/28.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabricLiveCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *sublab;

@property (nonatomic, copy) NSDictionary *dic;
@end
