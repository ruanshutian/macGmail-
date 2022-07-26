//
//  MainWindowsController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//

#import "MainWindowsController.h"
#import "MainLoginViewController.h"
#import "MailViewController.h"
@import GoogleSignIn;
@interface MainWindowsController ()
@property(nonatomic)MainLoginViewController*mainLoginViewController;
@property(nonatomic)MailViewController*mailViewController;
@end

@implementation MainWindowsController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    _mainLoginViewController = [[MainLoginViewController alloc] initWithNibName:@"MainLoginViewController" bundle:[NSBundle mainBundle]];
    self.contentViewController = _mainLoginViewController;
    //登陆邮箱切换view
    [_mainLoginViewController.mainLoginView.loginButton setAction:@selector(loginMail)];
    
//    _mailViewController = [[MailViewController alloc] initWithNibName:@"MailViewController" bundle:[NSBundle mainBundle]];
    
}
- (NSNibName)windowNibName
{
    return @"MainWindowsController";
}
-(void)loginMail
{
    _mailViewController = [[MailViewController alloc] initWithNibName:@"MailViewController" bundle:[NSBundle mainBundle]];
    self.contentViewController = _mailViewController;
    
    [self signInReady];
    
}

//==登陆授权==
-(void)signInReady
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
//    _config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    _session = [NSURLSession sessionWithConfiguration:_config];
    _signInConfig = [[GIDConfiguration alloc] initWithClientID:@"947400323996-smp0c8sfipu9sokumqbbsh0sdunn6rve.apps.googleusercontent.com"];
    
    NSArray *additionalScopes = @[
        @"https://mail.google.com/",
//        @"https://www.googleapis.com/auth/gmail.modify",
//        @"https://www.googleapis.com/auth/gmail.readonly",
//        @"https://www.googleapis.com/auth/gmail.metadata"
    ];
    [GIDSignIn.sharedInstance signInWithConfiguration:_signInConfig presentingWindow:( NSWindow *)self hint:nil callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        NSString *name = user.profile.name;
        NSLog(@"name =%@",name);
        if (error) { return; }
        if (user == nil) { return; }

        NSString *emailAddress = user.profile.email;

//        NSString *name = user.profile.name;
        NSLog(@"name =%@",name);
        
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;

        NSURL *profilePic = [user.profile imageURLWithDimension:320];
    }];

    

//    [GIDSignIn.sharedInstance signInWithConfiguration:_signInConfig presentingWindow:(NSWindow *)self hint:nil additionalScopes:additionalScopes callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//        NSLog(@"user = %@",user);
//        if (error) { return; }
//        if (user == nil) { return; }
//        self->_token =user.authentication.accessToken;
//        NSLog(@"user.grantedScopes = %@",user.grantedScopes);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self urlVisit];
//        });
//    }];
}

//获取messageId
-(void)urlVisit
{
    NSString *urlString = @"https://gmail.googleapis.com/gmail/v1/users/shutianruan00@gmail.com/messages/";

//    urlString =@"https://www.googleapis.com/auth/userinfo.email";
    NSURL *url =[[NSURL alloc] initWithString:urlString];
    [self getMssageId:url];

}
-(void)getMssageId:(NSURL*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString* token =_token;
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",token];
    [request addValue:authorization forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data = %@",data);
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for(NSInteger i =0 ;i<[dataDictionary[@"messages"] count];i++)
        {
            [self->_messageIdArray addObject:dataDictionary[@"messages"][i][@"id"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self mailVisit];
        });
    }];
    [task resume];
}
-(void)mailVisit
{
    NSMutableString *urlString =(NSMutableString *) @"https://gmail.googleapis.com/gmail/v1/users/shutianruan00@gmail.com/messages/";
    for(NSString*messageId in _messageIdArray)
    {
        NSMutableString *urlStringTemp = (NSMutableString *)[urlString stringByAppendingString:messageId];

        NSURL *url =[[NSURL alloc] initWithString:urlStringTemp];
        NSLog(@"url =%@",url);

        [self getMail:url :_mailRow:messageId];

    }
    
}

-(void)getMail:(NSURL*)url:(NSMutableArray <MailList *> *)mailRow:(NSString*)messageId
{
    NSLog(@"getMail");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *authorization = [NSString stringWithFormat:@"Bearer %@",_token];
    [request addValue:authorization forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data = %@",data);
        NSString*fileName = [NSString stringWithFormat:@"%@.txt",messageId];
        NSLog(@"fileName = %@",fileName);
        
        NSString*dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [self saveData:dataString :fileName];
        
       
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dataDictionary = %@",dataDictionary);
        

        
        //正文dataDictionary[@"snippet"]
        NSLog(@"dataDictionary[snippet] = %@",dataDictionary[@"snippet"]);
        //Date。 dataDictionary[@"payload"][@"headers"][13]
        NSMutableArray*headerArray = dataDictionary[@"payload"][@"headers"];
        
        MailList *mail = [[MailList alloc] init];
        mail.mailText = dataDictionary[@"snippet"];
//        NSCFString*s =[NSTaggedPointerString al]
        
        NSLog(@"-----detail = %@",dataDictionary[@"snippet"]);
        mail.mailText = [[mail.mailText mutableCopy] copy];
        NSLog(@"%@ %@", [dataDictionary[@"snippet"] class] ,dataDictionary[@"snippet"]);
        NSLog(@"%@ %p", [mail.mailText class] ,mail.mailText);
        
        for(NSDictionary*headerDict in headerArray)
        {
            
            NSString *name = headerDict[@"name"];
            NSString *value = headerDict[@"value"];
            //获取邮件发件人
            if([name isEqual:@"From"])
            {
                NSRange range = [value rangeOfString:@"<"];
                value = [value substringToIndex:range.location];
                if([value containsString:@"\""]){
                    value = [value substringFromIndex:1];
                }
                mail.mailName = value;
//                mail.mailGetter = value;
                
            }
            //获取邮件发件人
            if([name isEqual:@"To"])
            {
    //            NSLog(@"value = %@",value);
//                mail.mailSender = value;
            }
            //获取邮件接收时间
            if([name isEqual:@"Date"])
            {
    //            NSLog(@"value = %@",value);
    //            NSRange range = [value rangeOfString:@"+"];
    //            value = [value substringToIndex:range.location];
                mail.mailTime = value;
            }
            //获取邮件主题
            if([name isEqual:@"Subject"])
            {
    //            NSLog(@"value = %@",value);
//                mail.mailSubject = value;
            }
        }
        
//        [self->_mailRow addObject:mail];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self reloadMailData];
        });
        
    }];
    [task resume];
}

@end
