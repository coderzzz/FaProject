//
//  ColorMacro.h
//  AnyChatInterview
//
//  Created by bairuitech on 2017/3/23.
//  Copyright © 2017年 anychat. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

#define BaseColor [UIColor colorWithRed:0.0/255.0 green:160.0/255.0 blue:233.0/255.0 alpha:1]

#define LineColor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]

/**主颜色(蓝色)*/
#define GlobalMainColor  BaseColor
/**辅助色(深灰色)*/
#define GlobalMinorColor             [BRFACEX_Utils colorWithHexString:@"#999999"]
/**背景色(浅灰色)*/
#define GlobalBackgroundColor        [BRFACEX_Utils colorWithHexString:@"#f1f1f1"]
/**边框颜色(灰色)*/
#define GlobalBorderColor            [BRFACEX_Utils colorWithHexString:@"#dcdcdc"]
/**点缀色(红色)*/
#define GlobalEmbellishRedColor      [BRFACEX_Utils colorWithHexString:@"#f54343"]
/**点缀色(绿色)*/
#define GlobalEmbellishGreenColor    [BRFACEX_Utils colorWithHexString:@"#2ab059"]
/**字体主颜色(黑色)*/
#define GlobalMainFontColor          [BRFACEX_Utils colorWithHexString:@"#333333"]
/**字体辅助颜色(深灰色)*/
#define GlobalMinorFontColor         [BRFACEX_Utils colorWithHexString:@"#999999"]
/**选框字体颜色(灰色)*/
#define GlobalFontCheckBoxColor      [BRFACEX_Utils colorWithHexString:@"#bbbbbb"]
/**页面标题19号*/
#define GlobalTitleFontSize                [UIFont systemFontOfSize:19]
/**重要文字16号*/
#define GlobalImportantFontSize            [UIFont systemFontOfSize:16]
/**列表性内容14号*/
#define GlobalListContentFontSize          [UIFont systemFontOfSize:14]
/**注释性文字12号*/
#define GlobalNoteFontSize                 [UIFont systemFontOfSize:12]




#endif /* ColorMacro_h */
