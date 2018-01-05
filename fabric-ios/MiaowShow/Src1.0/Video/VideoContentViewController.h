//
//  VideoContentViewController.h
//  MiaowShow
//
//  Created by sam on 2017/9/30.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleItem.h"
@interface VideoContentViewController : UIViewController

@property (nonatomic, copy) NSArray *firstPageList;

@property (nonatomic, strong) ModuleItem *item;

@property (nonatomic, copy) NSString *areaName;


@property (copy, nonatomic) NSDictionary *caigou;

@property (copy, nonatomic) NSArray *adlist;

@property (strong , nonatomic)UICollectionView *collectionView;
@end
