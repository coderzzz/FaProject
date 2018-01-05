//
//  NSString+Utils.h
//  HWSDK
//
//  Created on 13-11-25.
//  Copyright (c) 2013年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K 
@interface NSString (Utils)
/**
   @desc 过滤html标签
   @return NSString 
  */
- (NSString *)filterHTML;

- (NSString *)md5;

- (BOOL)isEmpty;

- (BOOL)isLegalForIdNumber;

//计算大文件的MD5值
+ (NSString*)getFileMD5WithPath:(NSString*)path;
@end
