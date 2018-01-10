//
//  ZZImageView.m
//  Farbic
//
//  Created by bairuitech on 2017/12/13.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "ZZImageView.h"
#import "ZZImageCell.h"
#import "EaseMessageReadManager.h"
#import "CustomFlowLayout.h"
@interface ZZImageView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic)UICollectionView *collectionView;
@end

@implementation ZZImageView

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CustomFlowLayout *layout = [CustomFlowLayout new];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.maximumInteritemSpacing = 4;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        _collectionView.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"ZZImageCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"ig"];
        
        
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
    
    self.list = [NSMutableArray array];
    
    
}

- (void)setList:(NSMutableArray *)list{
    
    _list = list;
    [self.collectionView reloadData];
}
- (void)addTag:(ZZTag *)tag{
    
    [self.list addObject:tag];
    [self.collectionView reloadData];
}
- (void)removeTag:(ZZItem *)item{
    
    [self.list removeObject:item];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ig" forIndexPath:indexPath];
    ZZItem *tag = self.list[indexPath.row];
    if (tag.image) {
        cell.image.image = tag.image;
    }
    else{
        [cell.image sd_setImageWithURL:[NSURL URLWithString:tag.imageUrl] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.bounds.size.height, self.bounds.size.height);
}

#pragma mark - foot宽高


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.canDel) {
        
        NSMutableArray *images = [NSMutableArray array];
        for (ZZItem *tag in self.list) {
            
            if (tag.image) {
                
                [images addObject:tag.image];
            }else if ([tag.imageUrl hasPrefix:@"http"]){
                
                [images addObject:tag.imageUrl];
            }
            
        }
        
    [[EaseMessageReadManager defaultManager] showBrowserWithImages:images];
        
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"是否删除图片？"preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        ZZItem *tag = self.list[indexPath.row];
        [self removeTag:tag];
        if (self.DeleteItem && tag) {
            
            self.DeleteItem(tag);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

    
    

    
    
    
    
    
    
    
    
}


@end
