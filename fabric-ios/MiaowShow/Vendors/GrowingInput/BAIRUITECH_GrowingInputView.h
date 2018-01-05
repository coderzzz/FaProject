
#import <UIKit/UIKit.h>

typedef enum _QDGrowingInputType
{
    QDGrowingInputType_Text     = 0,
    QDGrowingInputType_Emoji    = 1,
} QDGrowingInputType;


@protocol BAIRUITECH_GrowingInputViewDelegate;
@interface BAIRUITECH_GrowingInputView : UIView
/**
 *  父控件
 */
@property (nonatomic, weak) UIView *parentView;
/**
 *  最小行数
 */
@property (nonatomic, assign) NSInteger minNumberOfLines;
/**
 *  内部textView的文本
 */
@property (nonatomic, strong) NSString *text;
/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, weak) id <BAIRUITECH_GrowingInputViewDelegate> delegate;
/**
 *  默认高度
  */
+ (CGFloat)defaultHeight;
/**
 *  激活键盘
 */
- (void)activateInput;
/**
 *  退键盘
 */
- (void)deactivateInput;

@end


@protocol BAIRUITECH_GrowingInputViewDelegate <NSObject>

@optional

- (void)growingInputViewEmojiBtnClick:(BAIRUITECH_GrowingInputView *)growingInputView;

- (BOOL)growingInputView:(BAIRUITECH_GrowingInputView *)growingInputView didSendText:(NSString *)text;
- (void)growingInputView:(BAIRUITECH_GrowingInputView *)growingInputView didChangeHeight:(CGFloat)height keyboardVisible:(BOOL)keyboardVisible;


- (BOOL)growingTextViewShouldBeginEditing:(BAIRUITECH_GrowingInputView *)growingInputView;
- (void)growingInputView:(BAIRUITECH_GrowingInputView *)growingInputView didRecognizer:(id)sender;

- (void)growingWillShow:(BAIRUITECH_GrowingInputView *)growingInputView;
- (void)growingWillHide:(BAIRUITECH_GrowingInputView *)growingInputView;
- (void)growingDidHide:(BAIRUITECH_GrowingInputView *)growingInputView;
- (void)growingTextViewDidEndEditing:(BAIRUITECH_GrowingInputView *)growingInputView;
@end

