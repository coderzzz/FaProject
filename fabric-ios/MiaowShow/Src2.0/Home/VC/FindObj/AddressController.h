//
//  AddressController.h
//  Farbic
//
//  Created by sam on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BaseViewController.h"

@interface AddressController : BaseViewController
@property (nonatomic, copy) void(^DidSelect)(NSDictionary *dic);
@end
