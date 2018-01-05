//
//  PopoverView.m
//  Popover
//
//  Created by lifution on 16/1/5.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "FaPopoverView.h"
#import "PopCell.h"

static float const kPopoverViewMargin = 8.f; ///< 边距
static float const kPopoverViewCellHeight = 40.f; ///< cell指定高度
static float const kPopoverViewArrowHeight = 13.f; ///< 箭头高度

// convert degrees to radians
float DegreesToRadians(float angle) {
    return angle*M_PI/180;
}

@interface FaPopoverView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) CAShapeLayer *borderLayer; ///< 边框Layer
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手势

#pragma mark - Data
@property (nonatomic, copy) NSArray<PopoverModel *> *actions;
@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度
@property (nonatomic, assign) BOOL isUpward; ///< 箭头指向, YES为向上, 反之为向下, 默认为YES.

@end

@implementation FaPopoverView

#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, _isUpward ? kPopoverViewArrowHeight : 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight);
}

#pragma mark - Setter
- (void)setHideAfterTouchOutside:(BOOL)hideAfterTouchOutside {
    _hideAfterTouchOutside = hideAfterTouchOutside;
    _tapGesture.enabled = _hideAfterTouchOutside;
}

- (void)setShowShade:(BOOL)showShade {
    _showShade = showShade;
    _shadeView.backgroundColor = _showShade ? [UIColor colorWithWhite:0.f alpha:0.18f] : [UIColor clearColor];
    if (_borderLayer) {
        _borderLayer.strokeColor = _showShade ? [UIColor clearColor].CGColor : _tableView.separatorColor.CGColor;
    }
}



#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    // data
    _actions = @[];
    _isUpward = YES;
    
     self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:0.7];

    
    // current view
//    self.backgroundColor = [UIColor whiteColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:_tableView];
    
    UINib *nib = [UINib nibWithNibName:@"PopCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"pop"];
}

/*! @brief 显示弹窗指向某个点,  */
- (void)showToPoint:(CGPoint)toPoint {
    NSAssert(_actions.count > 0, @"actions must not be nil or empty !");
    
    // 截取弹窗时相关数据
    float arrowWidth = 28;
    float cornerRadius = 6.f;
    float arrowCornerRadius = 2.5f;
    float arrowBottomCornerRadius = 4.f;
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (_windowWidth - toPoint.x < minHorizontalEdge) {
        toPoint.x = _windowWidth - minHorizontalEdge;
    }
    
    // 遮罩层
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = 200; // 宽度通过计算获取最大值
    CGFloat currentH = 250;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _isUpward ? (_windowHeight - toPoint.y - kPopoverViewMargin) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) { // 箭头指向下则移动到最后一行
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_actions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (_windowWidth - toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    // y: 箭头向下
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), _isUpward ? 0 : currentH); // 箭头顶点在当前视图的坐标
    CGFloat maskTop = _isUpward ? kPopoverViewArrowHeight : 0; // 顶部Y值
    CGFloat maskBottom = _isUpward ? currentH : currentH - kPopoverViewArrowHeight; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(180)
                      endAngle:DegreesToRadians(270)
                     clockwise:YES];
    // 箭头向上时的箭头位置
    if (_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(270)
                      endAngle:DegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(0)
                      endAngle:DegreesToRadians(90)
                     clockwise:YES];
    // 箭头向下时的箭头位置
    if (!_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)
                         controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:DegreesToRadians(90)
                      endAngle:DegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    if (!_showShade) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = maskPath.CGPath;
        borderLayer.lineWidth = 1;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = _tableView.separatorColor.CGColor;
        [self.layer addSublayer:borderLayer];
        _borderLayer = borderLayer;
    }
    
    [_keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, _isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
    }];
}




/*! @brief 点击外部隐藏弹窗 */
- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Public
+ (instancetype)FapopoverView {
    return [[self alloc] init];
}

/*! @brief 指向指定的View来显示弹窗 */
- (void)showToView:(UIView *)pointView withActions:(NSArray<PopoverModel *> *)actions {
    // 判断 pointView 是偏上还是偏下
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:_keyWindow];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = _windowHeight - CGRectGetMaxY(pointViewRect);
    // 弹窗箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    // 弹窗在 pointView 顶部
    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength - 5;
    }
    // 弹窗在 pointView 底部
    else {
        toPoint.y = CGRectGetMaxY(pointViewRect) + 5;
    }
    
    // 箭头指向方向
    _isUpward = pointViewUpLength <= pointViewDownLength;
    _actions = [actions copy];
    [self showToPoint:toPoint];
}

/*! @brief 指向指定的点来显示弹窗 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<PopoverModel *> *)actions {
    _actions = [actions copy];
    // 计算箭头指向方向
    _isUpward = toPoint.y <= _windowHeight - toPoint.y;
    [self showToPoint:toPoint];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

static NSString *kPopoverCellIdentifier = @"pop";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellIdentifier];
    PopoverModel *model = _actions[indexPath.row];
    cell.titllab.text =model.nickName;
    [cell.imagv sd_setImageWithURL:[NSURL URLWithString:model.userLogo] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndexRow:)]) {
            
            [self.delegate didSelectIndexRow:indexPath.row];
        }

        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end

