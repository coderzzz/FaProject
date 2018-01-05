//
//  FindObjController.h
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface FindObjController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSDictionary *dic;
@end
