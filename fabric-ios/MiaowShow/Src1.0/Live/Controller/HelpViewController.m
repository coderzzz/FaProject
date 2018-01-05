//
//  HelpViewController.m
//  MiaowShow
//
//  Created by sam on 2017/10/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpCell.h"
@interface HelpViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger index;
@end

@implementation HelpViewController

- (IBAction)next:(UIButton *)sender {
    
    if (_index <self.list.count) {
        
        NSDictionary *dic = self.list[_index];
        if (dic && self.next) {
            self.next(dic);
        }
    }
    
}


#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HelpCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"help"];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}

- (void)hide{
    
    if (self.hideBlock) {
        self.hideBlock();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point =[touch locationInView:self.mainView];
    
//    NSLog(@"----%f *********%f",point.x,point.y);
    
    if (point.y >0 && point.y <175) {
        
        return NO;
    }
    return YES;
}


- (void)setList:(NSMutableArray *)list{
    
    _list = list;
    _index = 0;
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
    
    
    HelpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"help" forIndexPath:indexPath];
    NSDictionary *dic = self.list[indexPath.row];
    if (indexPath.row == _index) {
        
        cell.bgimg.hidden = NO;
    }
    else{
        cell.bgimg.hidden = YES;
    }
    [cell.head sd_setImageWithURL:[NSURL URLWithString:dic[@"imgPath"]] placeholderImage:[UIImage imageNamed:@"112"]];
    cell.lab.text = dic[@"roomName"];

    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(125, 30);
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _index = indexPath.row;
    [self.collectionView reloadData];

    
}



@end
