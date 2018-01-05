//
//  MyFollowViewController.h
//  MiaowShow
//
//  Created by sam on 2017/9/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    TypeFollow  = 1,
    TypeHelp    = 2,
    TypeAgent   = 3,
    
}Type;
@interface MyFollowViewController : UITableViewController

@property (nonatomic, assign) Type type;

@end
