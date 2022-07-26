//
//  MainWindowsController.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//

#import <Cocoa/Cocoa.h>
#import "MailList.h"
@import GoogleSignIn;
NS_ASSUME_NONNULL_BEGIN

@interface MainWindowsController : NSWindowController
@property(nonatomic)GIDConfiguration*signInConfig;
@property(nonatomic)NSURLSession *session;
@property(nonatomic)NSString*token;
@property(nonatomic)NSURLSessionConfiguration *config;
@property(nonatomic)NSMutableArray*messageIdArray;

@property(nonatomic)NSMutableArray<MailList*>*mailRow;
@end

NS_ASSUME_NONNULL_END
