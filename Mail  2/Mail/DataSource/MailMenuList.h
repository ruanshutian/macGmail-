//
//  MailMenuList.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailMenuList : NSObject
@property(nonatomic)NSString*login;
@property(nonatomic)NSString*load;
@property(nonatomic)NSString*inbox;
@property(nonatomic)NSString*starred;
@property(nonatomic)NSString*draft;
@property(nonatomic)NSString*mutbox;
@property(nonatomic)NSString*more;
@property(nonatomic)NSString*empty;
@property(nonatomic)NSString*createNewLabel;
@end

NS_ASSUME_NONNULL_END
