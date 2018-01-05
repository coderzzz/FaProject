//
//  ALinLiveCollectionViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/23.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinLiveCollectionViewController.h"
#import "ALinLiveViewCell.h"

#import "ALinLiveFlowLayout.h"
//#import "ALinUser.h"
#import "ALinUserView.h"
#import "LiveUserModel.h"
@interface ALinLiveCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/** 用户信息 */
@property (nonatomic, weak) ALinUserView *userView;
@end

@implementation ALinLiveCollectionViewController

static NSString * const reuseIdentifier = @"ALinLiveViewCell";
#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT + 20);
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        [self.collectionView registerClass:[ALinLiveViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (ALinUserView *)userView
{
    if (!_userView) {
        ALinUserView *userView = [ALinUserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [userView setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
        }];
        
    }
    return _userView;
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];


//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
}

- (void)clickUser:(NSNotification *)notify
{
    if (notify.userInfo[@"user"] != nil) {
        ALinUser *user = notify.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALinLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.parentVc = self;
    [cell setClickRelatedLive:^{
      
        if (self.helpBack) {
            self.helpBack();
        }
        
    }];
//    LiveUserModel *model = [LiveUserModel new];
//    model.nickName = @"石小松";
//    model.playStream = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
//    model.userLogo = @"http://www.sinaimg.cn/lf/sports/logo85/52.png";
//    model.roomName = @"天佑直播间";
    
    cell.live = self.live;
//    cell.live = self.lives[self.currentIndex];
//    ALinLive *liv= [ALinLive a];
 
    
    
    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    return CGSizeZero;
}





/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
    
}

@end
