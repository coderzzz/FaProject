//
//  DCHandPickViewController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleItem.h"
@interface FabricContentViewController : UIViewController

@property (nonatomic, copy) NSArray *firstPageList;

@property (nonatomic, strong) ModuleItem *item;

@property (nonatomic, copy) NSString *areaName;


@property (copy, nonatomic) NSDictionary *caigou;

@property (copy, nonatomic) NSArray *adlist;

@property (strong , nonatomic)UICollectionView *collectionView;

@end
