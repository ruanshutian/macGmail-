//
//  MailMenuList.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/19.
//

#import "MailMenuList.h"

@implementation MailMenuList
- (instancetype)init
{
    self= [super init];
    if(self)
    {
        _login = @"Login";
        _load =@"Load";
        _inbox = @"Inbox";
        _starred = @"Starred";
        _draft = @"Draft";
        _mutbox = @"Mutbox";
        _more = @"More";
        _empty =@" ";
        _createNewLabel =@"+ create new label ";
    }
    return  self;
}
@end
