//
//  MailList.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailList : NSObject
@property(nonatomic)NSString*mailName;
@property(nonatomic)NSString*mailText;
@property(nonatomic)NSString*mailTime;

@property(nonatomic)NSString*mailGetter;
@property(nonatomic)NSString*mailSender;

@property(nonatomic)NSString*mailSubject;

@property(nonatomic)NSData*mailBody;
@end

NS_ASSUME_NONNULL_END
