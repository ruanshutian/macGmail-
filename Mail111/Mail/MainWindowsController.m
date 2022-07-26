//
//  MainWindowsController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//



#import "MainWindowsController.h"
#import "MainViewController.h"
#import "MailView.h"
@import  GoogleSignIn;

@interface MainWindowsController ()
@property(nonatomic)MainViewController*mainViewController;
@property(nonatomic)MailView*mailView;
@property(nonatomic)GIDConfiguration*signInConfig;

@property(nonatomic)NSURLSession *session;
@property(nonatomic)NSString*token;
@end

@implementation MainWindowsController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    _mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
    self.contentViewController = _mainViewController;
    
    _mailView = [[MailView alloc] init];
    
//    self.contentViewController = _mailView;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
//    self.contentViewController = _mailView;
    
}
- (NSNibName)windowNibName
{
    return @"MainWindowsController";
}
- (IBAction)loginClick:(id)sender {
    //https://myaccount.google.com/permissions
    //https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDSignIn#-signinwithconfiguration:presentingwindow:callback:
    self.contentViewController = _mailView;
//     _signInConfig = [[GIDConfiguration alloc] initWithClientID:@"947400323996-smp0c8sfipu9sokumqbbsh0sdunn6rve.apps.googleusercontent.com"];
//
//    NSArray *additionalScopes = @[
//        @"https://mail.google.com/",
//        @"https://www.googleapis.com/auth/gmail.modify",
//        @"https://www.googleapis.com/auth/gmail.readonly",
//        @"https://www.googleapis.com/auth/gmail.metadata"
//    ];
//    [GIDSignIn.sharedInstance signInWithConfiguration:_signInConfig presentingWindow:(NSWindow *)self hint:nil additionalScopes:additionalScopes callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//        if (error) { return; }
//        if (user == nil) { return; }
//
//
//        [GIDSignIn.sharedInstance addScopes:additionalScopes presentingWindow:(NSWindow*)self callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//            NSLog(@"error = %@",error);
//            NSLog(@"user.grantedScopes = %@",user.grantedScopes);
//        }];
//
//
//        NSString *driveScope = @"https://www.googleapis.com/auth/drive.readonly";
//
//        // Check if the user has granted the Drive scope
//        if (![user.grantedScopes containsObject:driveScope]) {
//          // request additional drive scope
//        }
//        NSLog(@"user.grantedScopes = %@",user.grantedScopes);
//        self->_token =user.authentication.accessToken;
//
//        NSString *urlString = @"https://gmail.googleapis.com/gmail/v1/users/shutianruan00@gmail.com/messages/";
////        urlString =@"https://gmail.googleapis.com/gmail/v1/users/shutianruan00@gmail.com/messages/181fb8a579b0112e";
//    //        urlString =@"https://www.googleapis.com/auth/contacts";
//        NSURL *url =[[NSURL alloc] initWithString:urlString];
//        [self getData:url];
//
//    }];
}

-(void)getData:(NSURL*)url
{
    NSLog(@"getData");
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request addValue:@"947400323996-lf7nubkrievivthuepsev9d9vhacfjim.apps.googleusercontent.com" forHTTPHeaderField:@"google-signin-client_id"];
    
    
    

    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",_token];
    [request addValue:authorization forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"statusCode = %ld",[(NSHTTPURLResponse *)response statusCode]);
        NSLog(@"data = %@",data);
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dataDictionary = %@",dataDictionary);
        }];
    [task resume];
    

}




@end
