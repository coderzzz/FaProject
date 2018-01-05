//
//  PayTypeViewController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface PayTypeViewController : BaseViewController
@property (nonatomic, copy) NSDictionary *tradeDict;
@property (nonatomic, copy) NSString *type;
-(void)show;


@end
