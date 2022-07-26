//
//  MainWindowsController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//



#import "MainWindowsController.h"

@import  GoogleSignIn;

@interface MainWindowsController ()

@property(nonatomic)GIDConfiguration*signInConfig;

@property(nonatomic)NSURLSession *session;
@property(nonatomic)NSString*token;
@end

@implementation MainWindowsController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
//    self.contentViewController = _mailView;
    
}
- (NSNibName)windowNibName
{
    return @"MainWindowsController";
}





@end
