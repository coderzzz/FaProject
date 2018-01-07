//
//  NSDate+Extension.h
//  QiongLiao
//
//  Created by 格式化油条 on 15/10/6.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSString *)dateWithTimesTamp:(NSString *)timeTamp;
/** 将日期转为字符串 */
+ (NSString *)stringConvertWithDate:(NSDate *)date;

/** 计算两个时间的差值 */
+ (NSInteger)calculateAgeFormDate:(NSDate *)formDate toDate:(NSDate *)toDate;
/** 获取当前时间 */
+ (NSString *)stringConvertWithNowDate;

/** 获取时间的年 */
+ (NSInteger)gainYearWithDate:(NSDate *)date;
/** 获取时间的月 */
+ (NSInteger)gainMonthWithDate:(NSDate *)date;
/** 获取时间的日 */
+ (NSInteger)gainDayWithDate:(NSDate *)date;
/** 获取时间的时 */
+ (NSInteger)gainHourWithDate:(NSDate *)date;
/** 获取时间的分 */
+ (NSInteger)gainMinuteWithDate:(NSDate *)date;


+ (NSString *)monthWithTimesTamp:(NSString *)timeTamp;
+ (NSString *)hourWithTimesTamp:(NSString *)timeTamp;


/** 将时间字符串转为自定义的格式 */
+ (NSString *)stringConvertWithDateString:(NSString *)dateString formatter:(NSString *)formatter;

/**根据某一个日期,获取n个月后的日期*/
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

/**字符串(秒) 转换成时间格式*/
+(NSDate *)dateConvertWithDateString:(NSString *)string;

/**时间转换成时间戳*/
+(NSString *)stringChangConvertWithDate:(NSDate *)date;

/**时间字符串转换成NSDate*/
+(NSDate *)dateChangConvertWithDateString:(NSString *)dateString;

@end
