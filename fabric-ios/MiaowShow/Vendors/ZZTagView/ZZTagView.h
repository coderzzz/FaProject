//
//  ZZTagView.h
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTag.h"
@interface ZZTagView : UIView
@property (strong , nonatomic)UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray *list;
@property (nonatomic, copy) void(^DidSelect)(ZZTag *tag);
- (void)addTag:(ZZTag *)tag;
@end
