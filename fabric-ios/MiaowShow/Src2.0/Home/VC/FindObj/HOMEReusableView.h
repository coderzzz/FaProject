//
//  HOMEReusableView.h
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HOMEReusableView : UICollectionReusableView

@property (strong, nonatomic) NSArray *adList;
@property (copy, nonatomic) void (^Click)(NSDictionary *dic);

- (void)getList:(NSArray *)list;
@end
