//
//  BAIRUITECH_BRTipView.m
//  share
//
//  Created by Mac on 26/5/16.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "BAIRUITECH_BRTipView.h"
#define LoadingText @"加载中"
#define aniImageViewAndTitleSpace (pixw(65/2))
@interface BAIRUITECH_BRTipView()
{
    int _flag;
    //旋转临时变量
    CGFloat _angle;
    NSTimer *_loadingTimer;
}
/**
 *  加载中定时器
 */
@property(nonatomic,strong) NSTimer *loadingTimer;
/**
 *  加载动画图片
 */
@property(nonatomic,strong) UIImageView *loadingImageView;
/**
 *  加载动画底部的描述label,就是加载中的三个label
 */
@property(nonatomic,strong) UILabel *loadingLabel;
/**
 *  加载失败重新加载按钮
 */
@property(nonatomic,strong) UIButton *loadFailedReloadBtn;
/**
 *  小提示label
 */
@property(nonatomic,strong) UILabel *tipLabel;
//旋转imgeview
@property(nonatomic,strong) UIImageView *outsideImageView;
//香imageView
@property (nonatomic,strong) UIImageView *xiangImageView;
-(void)setLoadingLabelText;
-(void)showTipTitle:(NSString *)title  delay:(NSTimeInterval)delay;
@end
@implementation BAIRUITECH_BRTipView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(instancetype )showTipTitle:(NSString *)title delay:(NSTimeInterval)delay{
    
    
    return nil;
}

+(void)showNetFailTip{
//    if (![XHGlobal share].isNetWorkEnable) {
//        [BAIRUITECH_BRTipView showTipTitle:@"网络不好,稍后再试吧"  delay:1];
//    }
}
#pragma mark 加载中-------------------------------------------
+(BAIRUITECH_BRTipView *)showLodingInView:(UIView *)_view{
//    [BAIRUITECH_BRTipView hideTipInView:_view];
//    BAIRUITECH_BRTipView *tipView=[[BAIRUITECH_BRTipView alloc]initWithFrame: _view.bounds];
//    tipView.center = _view.center;
//    tipView.backgroundColor=[UIColor clearColor];
//    [_view addSubview:tipView];
//    
////    UIImageView *aniImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, pixw(230), pixw(24), pixw(24))];
//    aniImageView.centerX = tipView.width/2;
//    UIImageView *outsideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pixw(24), pixw(24))];
//    [outsideImageView setImage:[UIImage imageNamed:@"loading_outside"]];
//    UIImageView *xiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pixw(24), pixw(24))];
//    [xiangImageView setImage:[UIImage imageNamed:@"loading_xiang"]];
//    [outsideImageView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
//    [aniImageView addSubview:outsideImageView];
//    [aniImageView addSubview:xiangImageView];
//    tipView.outsideImageView = outsideImageView;
//    tipView.xiangImageView = xiangImageView;
//    //旋转
//    tipView.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:tipView selector:@selector(startAnimation) userInfo:nil repeats:YES];
//    
//    
//    tipView.loadingImageView = aniImageView;
//    [tipView addSubview:aniImageView];
//    //设置动画总时间
//    //    aniImageView.animationDuration=0.9;
//    //设置重复次数,0表示不重复
//    //    aniImageView.animationRepeatCount=0;
//    //开始动画
//    //    [aniImageView startAnimating];
//    
//    tipView.loadingLabel=[[UILabel alloc]init];
//    
//    //加载中的三个点
//    
//    CGSize size=[[NSString stringWithFormat:@"%@...",LoadingText] sizeWithAttributes:@{NSFontAttributeName :tipView.loadingLabel.font}];
//    
//    //图片和标题之间的间隔
//    //让aniImageView 和 titleLabel 整体上下居中,然后再往上偏一点，看起来协调
//    
//    
//    aniImageView.y=(tipView.height-(aniImageView.height+aniImageViewAndTitleSpace+size.height))/2-pixw(60);
//    tipView.loadingLabel.frame=CGRectMake(aniImageView.x+aniImageView.width/5, CGRectGetMaxY(aniImageView.frame)+aniImageViewAndTitleSpace, size.width, size.height);
//    tipView.loadingLabel.centerX=tipView.width/2;
//    
//    //加载失败，添加失败按钮
//    tipView.loadFailedReloadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [tipView addSubview:tipView.loadFailedReloadBtn];
//    
//    [tipView.loadFailedReloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//    //tipView.loadFailedReloadBtn.titleLabel.font = [BRFont fontWithName:@"Heiti SC" size:45];
//    [tipView.loadFailedReloadBtn setTitleColor:[BAIRUITECH_Utils colorWithHexString:@"#fb6652"] forState:UIControlStateNormal];
//    
//    CGSize btnSize = [[NSString stringWithFormat:@"%@",tipView.loadFailedReloadBtn.titleLabel.text]  sizeWithAttributes:@{NSFontAttributeName:tipView.loadFailedReloadBtn.titleLabel.font}];
//    tipView.loadFailedReloadBtn.frame = CGRectMake(0, CGRectGetMaxY(tipView.loadingLabel.frame)+pixw(14), btnSize.width + 2*pixw(15), btnSize.height + 2*pixw(7.5));
//    tipView.loadFailedReloadBtn.centerX=tipView.width/2;
//    
//    tipView.loadFailedReloadBtn.layer.borderWidth = 1;
//    [tipView.loadFailedReloadBtn.layer setBorderColor:[[BAIRUITECH_Utils colorWithHexString:@"#fb6652"]CGColor]];
//    tipView.loadFailedReloadBtn.hidden=YES;
//    tipView.loadFailedReloadBtn.layer.masksToBounds=YES;
//    tipView.loadFailedReloadBtn.layer.cornerRadius=tipView.loadFailedReloadBtn.height/16;
//    
//    
//    return tipView;
    return nil;
}
+(BAIRUITECH_BRTipView *)showLodingInView:(UIView *)_view offSetY:(float)y{
    BAIRUITECH_BRTipView *tipView=[BAIRUITECH_BRTipView showLodingInView:_view];
    tipView.y+=y;
    return tipView;
}
#pragma mark 旋转动画
- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _outsideImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        _angle += 5;
    }];
    
}
#pragma mark 加载中... 动画
//-(void)setLoadingLabelText{
//    if (![self.loadingLabel.text isEqualToString:[NSString stringWithFormat:@"%@...",LoadingText]]) {
//        self.loadingLabel.text=[NSString stringWithFormat:@"%@.",self.loadingLabel.text];
//    }
//    else{
//        self.loadingLabel.text=LoadingText;
//    }
//}
#pragma mark 加载结果
-(void)successLoading{
    //移除视图,停掉计时器
    [_loadingTimer invalidate];
    _loadingTimer = nil;
    [self removeFromSuperview];
}
-(void)failedLoadingForRealoadTarget:(id)target action:(SEL)action{
//    [_loadingTimer invalidate];
//    _loadingTimer = nil;
//    self.loadFailedReloadBtn.hidden=NO;
//    [self failedLoadingForfailedReason:@"加载失败，请重试"];
//    
//    //整体往上移一些
//    //    self.loadingImageView.y-=pixw(45);
//    self.loadingLabel.y=CGRectGetMaxY(self.loadingImageView.frame)+aniImageViewAndTitleSpace;
//    self.loadFailedReloadBtn.y=CGRectGetMaxY(self.loadingLabel.frame)+pixw(14);
//    [self.loadFailedReloadBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
-(void)failedLoadingForfailedReason:(NSString *)reason{
//    [self.superview bringSubviewToFront:self];
//    
//    
//    //    [self.loadingTimer invalidate];
//    
//    self.loadingLabel.backgroundColor=[UIColor clearColor];
//    //self.loadingLabel.font = [BRFont fontWithName:@"Heiti SC" size:14.5 * 3];
//    self.loadingLabel.textColor=[BAIRUITECH_Utils colorWithHexString:@"#999999"];
//    [self addSubview:self.loadingLabel];
//    
//    self.loadingLabel.text=reason;
//    self.loadingLabel.textAlignment=NSTextAlignmentCenter;
//    self.loadingLabel.width=self.width;
//    self.loadingLabel.centerX=self.width/2;
//    self.backgroundColor=[UIColor clearColor];
//    [self.outsideImageView removeFromSuperview];
//    [self.xiangImageView removeFromSuperview];
//    self.loadingImageView.animationImages=nil;
//    [self.loadingImageView setSize:CGSizeMake(pixw(40), pixw(40))];
//    self.loadingImageView.centerX = self.width/2;
//    self.loadingImageView.image = [UIImage imageNamed:@"loading_fail"];
//    [self.loadingImageView stopAnimating];
}

#pragma mark ---------------------------------------------------
#pragma mark 转圈提示
+(BAIRUITECH_BRTipView *)showActivityInView:(UIView *)_view title:(NSString *)_title{
//    BAIRUITECH_BRTipView *tipView=[[BAIRUITECH_BRTipView alloc]init];
//    tipView.bounds=CGRectMake(0, 0, pixw(80), pixw(80));
//    tipView.center=CGPointMake(_view.width/2, _view.height/2);
//    tipView.layer.masksToBounds=YES;
//    tipView.layer.cornerRadius=tipView.height/16;
//    tipView.backgroundColor=[UIColor blackColor];
//    tipView.alpha=0.5;
//    [_view addSubview:tipView];
//    
//    
//    //转圈
//    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activity.center=CGPointMake(tipView.bounds.size.width/2, tipView.bounds.size.height/2-10);
//    [tipView addSubview:activity];
//    [activity startAnimating];
//    
//    //标题
//    tipView.loadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, pixw(55), pixw(80), pixw(15))];
//    tipView.loadingLabel.backgroundColor=[UIColor clearColor];
//    tipView.loadingLabel.text=_title;
//    tipView.loadingLabel.textAlignment=NSTextAlignmentCenter;
//    tipView.loadingLabel.font=[UIFont systemFontOfSize:15];
//    tipView.loadingLabel.textColor=[UIColor whiteColor];
//    [tipView addSubview:tipView.loadingLabel];
//    
//    return tipView;
    return nil;
}
//+(BAIRUITECH_BRTipView *)showActivityInViewXib:(UIView *)_view title:(NSString *)_title{
//    BAIRUITECH_BRTipView *tipView=[[BAIRUITECH_BRTipView alloc]init];
//    tipView.bounds=CGRectMake(0, 0, pixw(80), pixw(80));
//    tipView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    tipView.layer.masksToBounds=YES;
//    tipView.layer.cornerRadius=tipView.height/16;
//    tipView.backgroundColor=[UIColor blackColor];
//    tipView.alpha=0.5;
//    [_view addSubview:tipView];
//    
//    
//    //转圈
//    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activity.center=CGPointMake(tipView.bounds.size.width/2, tipView.bounds.size.height/2-10);
//    [tipView addSubview:activity];
//    [activity startAnimating];
//    
//    //标题
//    tipView.loadingLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, pixw(55), pixw(80), pixw(15))];
//    tipView.loadingLabel.backgroundColor=[UIColor clearColor];
//    tipView.loadingLabel.text=_title;
//    tipView.loadingLabel.textAlignment=NSTextAlignmentCenter;
//    tipView.loadingLabel.font=[UIFont systemFontOfSize:15];
//    tipView.loadingLabel.textColor=[UIColor whiteColor];
//    [tipView addSubview:tipView.loadingLabel];
//    
//    return tipView;
//}
#pragma mark 显示图片----------------------------------
+(void)showTipImgName:(NSString *)imgName delay:(NSTimeInterval)delay{
    BAIRUITECH_BRTipView *tipView=[[BAIRUITECH_BRTipView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    for(UIView *view in window.subviews){
        if ([view isKindOfClass:[BAIRUITECH_BRTipView class]]) {
            [view removeFromSuperview];
        }
    }
    tipView.center=window.center;
    tipView.layer.masksToBounds=YES;
    tipView.layer.cornerRadius=2;
    UIImage *image=[UIImage imageNamed:imgName];
    tipView.backgroundColor=[UIColor colorWithPatternImage:image];
    [window addSubview:tipView];
    tipView.bounds=CGRectMake(0, 0, image.size.width, image.size.height);
    tipView.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [tipView hideTipViewDelay:delay];
}
#pragma mark 小提示-------------------------------------
//+(BAIRUITECH_BRTipView *)showTipTitle:(NSString *)title delay:(NSTimeInterval)delay{
//    BAIRUITECH_BRTipView *tipView=[[BAIRUITECH_BRTipView alloc]init];
//    UIWindow *window=[UIApplication sharedApplication].delegate.window;
//    for(UIView *view in window.subviews){
//        if ([view isKindOfClass:[BAIRUITECH_BRTipView class]]) {
//            [view removeFromSuperview];
//        }
//    }
//    CGSize size ;
//    if ([title isKindOfClass:[NSString class]]) {
//        
////        @{NSFontAttributeName :
//       size =[title boundingRectWithSize:CGSizeMake(pixw(300), pixw(100)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18] } context:nil].size;
////        size=[title sizeWithFont:[BRFont scaleFontSize:52] constrainedToSize:CGSizeMake(pixw(300), pixw(100))];
//    }
//    tipView.size=CGSizeMake(size.width+pixw(30), size.height+pixw(16));
//    tipView.center=CGPointMake(window.width/2, window.height * 0.6);
//    tipView.layer.masksToBounds=YES;
//    tipView.layer.cornerRadius=2;
//    [window addSubview:tipView];
//    
//    //标题
//    UILabel *_titleLabel=[[UILabel alloc]initWithFrame:tipView.bounds];
//    _titleLabel.numberOfLines=0;
//    _titleLabel.backgroundColor=[UIColor clearColor];
//    _titleLabel.text=title;
//    _titleLabel.textAlignment=NSTextAlignmentCenter;
//    _titleLabel.font=[UIFont systemFontOfSize:18];
//    _titleLabel.textColor=[UIColor whiteColor];
//    [tipView addSubview:_titleLabel];
//    tipView.backgroundColor=[BAIRUITECH_Utils colorWithHexString:@"000000" alpha:0.7];
//    [tipView hideTipViewDelay:delay];
//    tipView.tipLabel=_titleLabel;
//    return  tipView;
//}
//
//+(BAIRUITECH_BRTipView *)showNoBgTipTitle:(NSString *)title delay:(NSTimeInterval)delay{
//    BAIRUITECH_BRTipView *tipView=[BAIRUITECH_BRTipView showTipTitle:title delay:delay];
//    tipView.backgroundColor=[UIColor clearColor];
//    tipView.tipLabel.textColor=[BAIRUITECH_Utils colorWithHexString:@"999999"];
//    return tipView;
//}
//
//+(BAIRUITECH_BRTipView *)showRedTipTitle:(NSString *)title delay:(NSTimeInterval)delay{
//    BAIRUITECH_BRTipView *tipView=[BAIRUITECH_BRTipView showTipTitle:title delay:delay];
//    tipView.backgroundColor=[BAIRUITECH_Utils colorWithHexString:@"fb6652"];
//    tipView.tipLabel.textColor=[UIColor whiteColor];
//    return tipView;
//}

-(void)hideTipViewDelay:(float)delay{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}
#pragma mark 删除视图中的tipView **********************
+(void)hideTipInView:(UIView *)_view{
    for(__strong UIView *view in _view.subviews){
        if([view isKindOfClass:[BAIRUITECH_BRTipView class]]){
            BAIRUITECH_BRTipView *tipView=(BAIRUITECH_BRTipView *)view;
            [tipView removeFromSuperview];
            tipView=nil;
        }
    }
}
@end
