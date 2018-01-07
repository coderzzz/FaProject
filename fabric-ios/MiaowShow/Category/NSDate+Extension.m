//
//  NSDate+Extension.m
//  QiongLiao
//
//  Created by 格式化油条 on 15/10/6.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)stringConvertWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)stringConvertWithNowDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDateString = [dateFormatter stringFromDate:currentDate];
    return nowDateString;
}

+ (NSInteger)calculateAgeFormDate:(NSDate *)formDate toDate:(NSDate *)toDate {
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [userCalendar components:NSCalendarUnitYear fromDate:formDate toDate:toDate options:NSCalendarWrapComponents];
    
    NSInteger year =  [components year];
    
    return year;
}

+ (NSInteger)gainYearWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSString *yearString = [formatter stringFromDate:date];
    
    return [yearString integerValue];
}

+ (NSInteger)gainMonthWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M";
    NSString *monthString = [formatter stringFromDate:date];
    
    return [monthString integerValue];
}
+ (NSInteger)gainDayWithDate:(NSDate *)date {
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d";
    NSString *dayString = [formatter stringFromDate:date];
    
    return [dayString integerValue];
}

/** 获取时间的时 */
+ (NSInteger)gainHourWithDate:(NSDate *)date;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h";
    NSString *hourString = [formatter stringFromDate:date];
    
    return [hourString integerValue];
}
/** 获取时间的分 */
+ (NSInteger)gainMinuteWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"m";
    NSString *minuteString = [formatter stringFromDate:date];
    
    return [minuteString integerValue];
}

+ (NSString *)stringConvertWithDateString:(NSString *)dateString formatter:(NSString *)formatter {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
    
    NSDate *date = [dateFormatter dateFromString:dateString];

    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    
    customDateFormatter.dateFormat = formatter;
    
    return [customDateFormatter stringFromDate:date];
}

+ (NSString *)dateWithTimesTamp:(NSString *)timeTamp{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeTamp longLongValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";

    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (NSString *)monthWithTimesTamp:(NSString *)timeTamp{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeTamp longLongValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"MM-dd";
    
    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)hourWithTimesTamp:(NSString *)timeTamp{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeTamp longLongValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
    return confromTimespStr;
}



+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

+(NSDate *)dateConvertWithDateString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH-mm-ss"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:string.integerValue];
    //NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimesp;
}

+(NSString *)stringChangConvertWithDate:(NSDate *)date
{
    NSTimeInterval time = [date timeIntervalSince1970];
    long long int timeDate = (long long int)time;
    NSString *dataString = [NSString stringWithFormat:@"%lld",timeDate];
    return dataString;
}

+(NSDate *)dateChangConvertWithDateString:(NSString *)dateString
{
    
    // 日期格式化类
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    
    format.dateFormat = @"yyyy-MM-dd";
    
    // NSString * -> NSDate *
    
    NSDate *data = [format dateFromString:dateString];
    //转换成字符串
   // NSString *newString = [format stringFromDate:data];
    return data;
}
@end
