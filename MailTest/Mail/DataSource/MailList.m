//
//  MailList.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MailList.h"

@implementation MailList
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _mailName = @"name";
        _mailText = @"text";
        _mailTime = @"time";
    }
    return self;
}
@end
