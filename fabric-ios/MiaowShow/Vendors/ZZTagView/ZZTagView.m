//
//  ZZTagView.m
//  Farbic
//
//  Created by bairuitech on 2017/12/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ZZTagView.h"
#import "ZZTagCell.h"
#import "ZZTag.h"
#import "CustomFlowLayout.h"
@interface ZZTagView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@implementation ZZTagView

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CustomFlowLayout *layout = [CustomFlowLayout new];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.maximumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        _collectionView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"ZZTagCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"z"];

        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}



-(void)awakeFromNib{
    NSLog(@"awakeFromNib");
    [super awakeFromNib];
    [self setUp];
}
- (id)init{
    
    self = [super init];
    [self setUp];
    return self;
}

- (void)setUp{
    
    
    self.collectionView.backgroundColor = [UIColor clearColor];

}



- (void)setList:(NSMutableArray *)list{
    
    _list = list;
    [self.collectionView reloadData];
}
- (void)addTag:(ZZTag *)tag{
    
    if (!(self.list.count>0)) {
        
        self.list = [NSMutableArray array];
    }
    [self.list addObject:tag];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return _list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ZZTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"z" forIndexPath:indexPath];
    ZZTag *tag = _list[indexPath.row];
    [cell setZZTag:tag];
   
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTag *tag = _list[indexPath.row];
    return CGSizeMake(tag.sizes.width, tag.height);
}

#pragma mark - foot宽高


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.DidSelect) {
        self.DidSelect(_list[indexPath.row]);
    }
    
}


@end
