//
//  PrivateListController.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FabricSocket.h"
#import "EaseMessageViewController.h"
@interface PrivateListController : UIViewController
@property (nonatomic, strong) FabricSocket *socket;
@property (strong, nonatomic) EaseMessageViewController *chatVC;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (void)addPrivateMsg:(NSDictionary *)msg formUser:(NSString *)userId;
@end
