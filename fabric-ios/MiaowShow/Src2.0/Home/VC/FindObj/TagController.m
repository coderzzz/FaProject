//
//  TagController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/5.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "TagController.h"


// Controllers

// Models

// Views


/* cell */
#import "AreaCell.h"
/* head */
/* foot */


// Vendors
// Categories
// Others

@interface TagController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end
/* cell */
static NSString *const DCGoodsCountDownCellID = @"cell";



@implementation TagController
{
    NSInteger _proIndex;
}
#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 30, SCREEN_WIDTH, 200);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellWithReuseIdentifier:DCGoodsCountDownCellID];
        

        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加标签";
    _proIndex = 0;
    [self loadDatas];
}


- (IBAction)done:(id)sender {
    
    if (self.ClickTag && _gridItem.count>0) {
        
        NSDictionary *dic = _gridItem[_proIndex];
        self.ClickTag(dic[@"name"],[NSString stringWithFormat:@"%@",dic[@"id"]]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - initialize


#pragma mark - 加载数据

- (void)loadDatas{
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_tags:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            
            _gridItem = object[@"data"];
            
            [self.collectionView reloadData];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) { //10属性
        return _gridItem.count;
    }

    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    AreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsCountDownCellID forIndexPath:indexPath];

        
    if (indexPath.row == _proIndex) {
//            cell.lab.backgroundColor = MainColor;
        cell.lab.textColor = Color;
        cell.lab.layer.borderColor = Color.CGColor;

    }else{
        
//            cell.lab.backgroundColor = [UIColor clearColor];
        cell.lab.textColor = [UIColor darkGrayColor];
        cell.lab.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    
    cell.lab.text = _gridItem[indexPath.row][@"name"];
    
    gridcell = cell;
    
    
    return gridcell;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH/3 - 2, 45);
}




/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
        
    _proIndex = indexPath.row;
  
    [self.collectionView reloadData];
    
}

@end
