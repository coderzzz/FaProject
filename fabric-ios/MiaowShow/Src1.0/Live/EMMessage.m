//
//  EMMessage.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "EMMessage.h"

@implementation EMMessage

- (id)initWithConversationID:(NSString *)aConversationId
                        from:(NSString *)aFrom
                          to:(NSString *)aTo
                        body:(EMMessageBody *)aBody
                         ext:(NSDictionary *)aExt{
    
    self = [super init];
    self.body = aBody;
    
    return self;
}
@end
