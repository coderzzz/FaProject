//
//  BAIRUITECH_BRTipView.h
//  share
//
//  Created by Mac on 26/5/16.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAIRUITECH_BRTipView : UIView
/**
 *  显示小提示,加到Window上边的
 *
 *  @param title <#title description#>
 *  @param delay 过多久消失
 */
+(instancetype )showTipTitle:(NSString *)title delay:(NSTimeInterval)delay;


/**
 *  显示加载中，默认位置是在view的正中间
 *
 *  @param _view 加载中的视图
 *
 *  @return <#return value description#>
 */
+(BAIRUITECH_BRTipView *)showLodingInView:(UIView *)_view;
/**
 *   显示加载中，默认位置是在view的正中间,但是会有y的偏移
 *
 *  @param _view
 *  @param y     y为正数 向下，y 为负数，向上
 *
 *  @return <#return value description#>
 */
+(BAIRUITECH_BRTipView *)showLodingInView:(UIView *)_view offSetY:(float)y;
/**
 *  加载成功
 */
-(void)successLoading;
/**
 *  加载失败
 *
 *  @param _view  <#_view description#>
 *  @param action 加载失败，点击重新加载所走的方法
 */
-(void)failedLoadingForRealoadTarget:(id)target action:(SEL)action;
/**
 *  加载失败
 *  @param _view  <#_view description#>
 *  @param reason 失败原因
 */
-(void)failedLoadingForfailedReason:(NSString *)reason;



/**
 *  转圈加提示
 *
 *  @param _view  <#_view description#>
 *  @param _title 转圈下边的标题
 *
 *  @return <#return value description#>
 */
+(BAIRUITECH_BRTipView *)showActivityInView:(UIView *)_view title:(NSString *)_title;

+(BAIRUITECH_BRTipView *)showActivityInViewXib:(UIView *)_view title:(NSString *)_title;

/**
 *  没有背景的小提示
 *
 *  @param title <#title description#>
 *  @param delay <#delay description#>
 */
+(BAIRUITECH_BRTipView *)showNoBgTipTitle:(NSString *)title delay:(NSTimeInterval)delay;

//电商加入购物车提示
+(BAIRUITECH_BRTipView *)showRedTipTitle:(NSString *)title delay:(NSTimeInterval)delay;

/**
 *  显示图片提示
 *
 *  @param imgName 要显示的图片
 *  @param delay   过多久消失
 */
+(void)showTipImgName:(NSString *)imgName delay:(NSTimeInterval)delay;

+(void)hideTipInView:(UIView *)_view;
//提示,网络不好,稍后再试吧
+(void)showNetFailTip;
@end
