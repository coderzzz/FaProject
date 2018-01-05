//
//  EMMessageBody.h
//  MiaowShow
//
//  Created by bairuitech on 2017/10/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
*!
*  \~chinese
*  消息体类型
*
*  \~english
*  Message body type
*/
typedef enum {
    EMMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
    EMMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
    EMMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
    EMMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
    EMMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
    EMMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
    EMMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Command */
} EMMessageBodyType;

/*!
 *  \~chinese
 *  消息体
 *
 *  \~english
 *  Message body
 */
@interface EMMessageBody : NSObject

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
@property (nonatomic, assign) EMMessageBodyType type;
@end
