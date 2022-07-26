//
//  MailDetailView.h
//  Mail
//
//  Created by Aron Ruan on 2022/7/20.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MailDetailView : NSView
@property(nonatomic)NSView*view;
@property(nonatomic)NSButton*backButton;
@property(nonatomic)NSButton*subjectTextButton;
@property(nonatomic)NSButton*senderNameTextButton;
@property(nonatomic)NSButton*dateTextButton;
@property(nonatomic)NSButton*getNameTextButton;
@property(nonatomic)WKWebView*mailWebView;
@end

NS_ASSUME_NONNULL_END
