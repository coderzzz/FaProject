//
//  BAIRUITECH_BRAccoutTool.m
//  SuperIntercom
//
//  Created by Mac on 16/4/25.
//  Copyright © 2016年 AnyChat. All rights reserved.
//

#import "BAIRUITECH_BRAccoutTool.h"
#import "BAIRUITECH_BRAccount.h"

#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#define kSearchHistoryKey @"searchHistory"

@implementation BAIRUITECH_BRAccoutTool

static BAIRUITECH_BRAccoutTool* _instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

+ (void)saveAccount:(BAIRUITECH_BRAccount * )account {
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFile];
}

+ (BAIRUITECH_BRAccount * )account {
    // 取出账号
    BAIRUITECH_BRAccount * account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
    if (!(account.token.length>0)) {
        account = [BAIRUITECH_BRAccount new];
        account.userId = @"0";
        account.token = @"";
    }
    // 判断是否过期
//    LOG(@"%@",AccountFile);
//    if ([[NSDate date] compare:account.expiresIn] == NSOrderedAscending) { //还没有过期
        return account;
//    }else {
//        return nil;
//    }
}

+ (BOOL)removeAccount {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [docDir stringByAppendingPathComponent:@"account.data"];
    
//    NSString *filePath = [CreditTool getFilePathWithDocumentDir:@"account.data"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        //LOG(@"account.data file delete success");
        return [fileManager removeItemAtPath:path error:nil];
    }
    //清除搜索历史记录的磁盘缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSearchHistoryKey];
    //LOG(@"account.data file delete false");
    return false;
}
@end
