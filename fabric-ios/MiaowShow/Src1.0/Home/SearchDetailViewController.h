//
//  SearchDetailViewController.h
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailViewController : UIViewController

@property (copy, nonatomic) NSString *placeHolderText;
@property (copy, nonatomic) NSDictionary *searchData;
@property (copy, nonatomic) void(^push)(NSDictionary *dic);
@end
