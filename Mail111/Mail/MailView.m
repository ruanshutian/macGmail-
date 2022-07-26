//
//  MailView.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//
#import <Foundation/Foundation.h>
#import<Cocoa/Cocoa.h>
#import "MailView.h"
#import "CellTableView.h"
#import "SubMailView.h"
@import GoogleSignIn;

@interface Mail : NSObject
@property(nonatomic)NSString*mailName;
@property(nonatomic)NSString*mailText;
@property(nonatomic)NSString*mailTime;

@property(nonatomic)NSString*mailSubject;
@property(nonatomic)NSString*mailSender;
@property(nonatomic)NSString*mailGetter;


@end
@implementation Mail
- (instancetype)init
{
    self = [super init];
    if(self)
    {
//        _mailName = @"name";
//        _mailText = @"text";
    }
    return self;
}
@end


@interface MailView ()<NSTableViewDataSource,NSTableViewDelegate>

@property(nonatomic)NSMutableArray*selecMenu;
@property(nonatomic)NSMutableArray<Mail*>*mailRow;

@property(weak)IBOutlet NSTableView *MenuTableView;
//@property(weak)IBOutlet NSTableView *tableView;
@property(weak)IBOutlet NSTableView *tableView;

@property(nonatomic)GIDConfiguration*signInConfig;

@property(nonatomic)NSURLSession *session;
@property(nonatomic)NSString*token;

@property(nonatomic)NSMutableArray*messageIdArray;

@property(nonatomic)NSView*subMailView;

@property(nonatomic)NSString *homePath;

@property(nonatomic)NSTextView*text;

@property(nonatomic)NSInteger row;

@end

@implementation MailView
NSUserDefaults* defaults = nil;
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _messageIdArray = [[NSMutableArray alloc] init];
        _selecMenu = [[NSMutableArray alloc] init];
        _mailRow = [[NSMutableArray alloc] init];
        [_selecMenu addObject:@"login"];
        [_selecMenu addObject:@"load"];
        [_selecMenu addObject:@"Inbox"];
        [_selecMenu addObject:@"Starred"];
        [_selecMenu addObject:@"Draft"];
        [_selecMenu addObject:@"Outbox"];
        [_selecMenu addObject:@"More"];
        [_selecMenu addObject:@" "];
        [_selecMenu addObject:@"+ create new label"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
        
//        NSTextView*headerView = [[NSTextView alloc] initWithFrame:CGRectMake(400, 700, 20, 20)];
//        headerView.backgroundColor = [NSColor blackColor];
//        [self.view addSubview:headerView];
//        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//        NSTableView*tableView = [
//        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_tableView.superview.superview attribute:NSLayoutAttributeLeft relatedBy:0 toItem:_tableView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:600];
//        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_tableView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_tableView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//        NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
//        [_tableView.superview addConstraints:ConstraintsArray];
        
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self signInReady];
    

}

//==登陆授权==
-(void)signInReady
{
    
    _signInConfig = [[GIDConfiguration alloc] initWithClientID:@"947400323996-smp0c8sfipu9sokumqbbsh0sdunn6rve.apps.googleusercontent.com"];
    
    NSArray *additionalScopes = @[
        @"https://mail.google.com/",
//        @"https://www.googleapis.com/auth/gmail.modify",
//        @"https://www.googleapis.com/auth/gmail.readonly",
//        @"https://www.googleapis.com/auth/gmail.metadata"
    ];

    [GIDSignIn.sharedInstance signInWithConfiguration:_signInConfig presentingWindow:(NSWindow *)self hint:nil additionalScopes:additionalScopes callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        if (error) { return; }
        if (user == nil) { return; }
        self->_token =user.authentication.accessToken;
        NSLog(@"user.grantedScopes = %@",user.grantedScopes);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self urlVisit];
        });
    }];
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
//    NSMutableString*urlStringTemp = (NSMutableString *)[urlString stringByAppendingString:@"181fb8a579b0112e"];
//    NSURL *url =[[NSURL alloc] initWithString:urlStringTemp];
//    NSLog(@"url =%@",url);
//    
//    [self getMail:url :_mailRow];
    
}

-(void)getMail:(NSURL*)url:(NSMutableArray <Mail *> *)mailRow:(NSString*)messageId
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
        [self saveData:dataString :fileName];
        
       
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dataDictionary = %@",dataDictionary);
        

        
        //正文dataDictionary[@"snippet"]
        NSLog(@"dataDictionary[snippet] = %@",dataDictionary[@"snippet"]);
        //Date。 dataDictionary[@"payload"][@"headers"][13]
        NSMutableArray*headerArray = dataDictionary[@"payload"][@"headers"];
        
        Mail *mail = [[Mail alloc] init];
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
                mail.mailGetter = value;
                
            }
            //获取邮件发件人
            if([name isEqual:@"To"])
            {
    //            NSLog(@"value = %@",value);
                mail.mailSender = value;
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
                mail.mailSubject = value;
            }
        }
        
        [self->_mailRow addObject:mail];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadMailData];
        });
        
    }];
    [task resume];
}

- (IBAction)menuClick:(id)sender {
    NSInteger row =[_MenuTableView clickedRow];
//    NSLog(@"row = %ld",row);
    if(row<0)
    {
        return;
    }
    if([_selecMenu[row] isEqual:@"login"])
    {
        [_mailRow removeAllObjects];
//        [_tableView reloadData];
        [self signInReady];
    }
    if([_selecMenu[row] isEqual:@"load"])
    {
        [_mailRow removeAllObjects];
//        [_tableView reloadData];
        [self getMailDataClick];
    }
}

//保存邮件到缓存
-(void)saveData:(NSString*)data:(NSString*)fileName
{
    NSError *error;
    BOOL success = [data writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(success){
        NSLog(@"saveSelectionToFile done wirting,fileName is %@ ",fileName);
    }else{
        NSLog(@"writing failed = %@",[error localizedDescription]);
    }
}

//=============================获取离线邮件缓存==============================
- (void)getMailDataClick{
//    NSLog(@" geiMailDataClick ");
    _homePath = NSHomeDirectory();
//    NSLog(@"_homePath根目录:%@", _homePath);
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *mailDataFileNameArr = [manager contentsOfDirectoryAtPath:_homePath error:&error];
    for(NSString* mailDataFileName in mailDataFileNameArr)
    {
        if([mailDataFileName containsString:@".txt"])
        {
//            NSLog(@"mailDataFileName = %@",mailDataFileName);
            [self getMailData:mailDataFileName];
        }
//        else{
//            return;
//        }
    }
}
//读取缓存的邮件
-(void)getMailData:(NSString*)mailDataFileName
{
    NSError *error;
    NSString*path = [[NSString alloc] initWithFormat:@"%@/%@",_homePath,mailDataFileName];
    NSString *str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&error];
    
//    NSLog(@"dataDictionary = %@",dataDictionary);
//    NSLog(@"dataDictionary[snippet] = %@",dataDictionary[@"snippet"]);
    //Date。 dataDictionary[@"payload"][@"headers"][13]
    NSMutableArray*headerArray = dataDictionary[@"payload"][@"headers"];
    Mail *mail = [[Mail alloc] init];
    
    mail.mailText = dataDictionary[@"snippet"];
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
            mail.mailGetter = value;
            
        }
        //获取邮件发件人
        if([name isEqual:@"To"])
        {
//            NSLog(@"value = %@",value);
            mail.mailSender = value;
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
            mail.mailSubject = value;
        }
    }
    
    [self->_mailRow addObject:mail];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadMailData];
    });
}
//
-(void)reloadMailData
{
    [_tableView reloadData];
    
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _mailRow.count ;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSLog(@"_mailRow.count =%ld  row =%ld ",_mailRow.count,row);
//    NSLog(@" _mailRow[row] = %@",_mailRow[row]);
    return _mailRow[row];
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row API_AVAILABLE(macos(10.7)) {
    CellTableView *rowView = [[CellTableView alloc] init];
    //rowView.backgroundColor = [NSColor blackColor];
    Mail*mail = [_mailRow objectAtIndex:row];
    rowView.nameView.string = mail.mailName;
    rowView.textView.string = mail.mailText;
    rowView.timeView.string = mail.mailTime;
//    [rowView.collectMailButton setAction:@selector(collectMail:)];
    return rowView;
}
//-(IBAction)collectMail:(id) sender{
//    NSInteger row =[_tableView clickedRow];
//    NSLog(@"row = %ld",row);
// }

//===================获取邮件detail===================
- (IBAction)getMailClick:(id)sender {
    NSInteger row =[_tableView clickedRow];
    NSLog(@"row = %ld",row);
    [self getSubMailView:row];
}


//点击邮件detail添加subView
-(void)getSubMailView:(NSInteger)row
{
    _subMailView = [[NSView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSTextField*backGroundField=[[NSTextField alloc] initWithFrame:CGRectMake(_MenuTableView.frame.size.width+11.5, 0, self.view.frame.size.width-_MenuTableView.frame.size.width-11.5, self.view.frame.size.height)];
    backGroundField.bordered = YES;
    backGroundField.selectable = NO;
    backGroundField.editable =NO;
    [_subMailView addSubview:backGroundField];
    
    
    NSButton*removeSubViewButton = [[NSButton alloc] initWithFrame:CGRectMake(_MenuTableView.frame.size.width, self.view.frame.size.height - 50, 50, 50)];
    removeSubViewButton.title = @"<-";
    [removeSubViewButton setAction:@selector(removeSubView) ];
    removeSubViewButton.bordered = NO;
    [_subMailView addSubview:removeSubViewButton];
    
    NSTextView*Header = [[NSTextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + _MenuTableView.frame.size.width+50, self.view.frame.size.height - 50 + 17, self.view.frame.size.width - _MenuTableView.frame.size.width - 50, 15)];
    NSString*subjectTemp = [[NSString alloc] initWithFormat:@" Subject: %@",_mailRow[row].mailSubject];
    [Header setString:subjectTemp];
    Header.editable = NO;
    [_subMailView addSubview:Header];
    
//    NSTextView*bodyHeader = [[NSTextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + _MenuTableView.frame.size.width +13, self.view.frame.size.height - 50 -50, self.view.frame.size.width - _MenuTableView.frame.size.width -13 , 50)];
//    [bodyHeader setString:@"bodyHeader"];
//    [_subMailView addSubview:bodyHeader];
    NSTextView*bodyHeaderGetter = [[NSTextView alloc] initWithFrame:CGRectMake(_MenuTableView.frame.size.width +13 +50, self.view.frame.size.height - 50 -50 +30, self.view.frame.size.width - _MenuTableView.frame.size.width -13 -50 -150 , 15)];
    [bodyHeaderGetter setString:_mailRow[row].mailGetter];
    bodyHeaderGetter.editable =NO;
    [_subMailView addSubview:bodyHeaderGetter];
    
    NSTextView*bodyHeaderTime = [[NSTextView alloc] initWithFrame:CGRectMake( self.view.frame.size.width-150, self.view.frame.size.height - 50 -50 +30, 150 , 15)];
    [bodyHeaderTime setString:_mailRow[row].mailTime];
    bodyHeaderTime.editable =NO;
    [_subMailView addSubview:bodyHeaderTime];
    
    NSTextView*bodyHeadersender = [[NSTextView alloc] initWithFrame:CGRectMake(_MenuTableView.frame.size.width +13 +50, self.view.frame.size.height - 50 -50 +10, self.view.frame.size.width - _MenuTableView.frame.size.width -13 -50 -150 , 15)];
    NSString*bodyHeadersenderStringTemp =[[NSString alloc] initWithFormat:@"To : %@",_mailRow[row].mailSender];
    bodyHeadersender.editable=NO;
    [bodyHeadersender setString:bodyHeadersenderStringTemp];
    [_subMailView addSubview:bodyHeadersender];
    
    _text = [[NSTextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + _MenuTableView.frame.size.width +13, self.view.frame.origin.y, self.view.frame.size.width - _MenuTableView.frame.size.width -13 , self.view.frame.size.height - 50 -50)];
    //获取每一row的邮件detail
    NSString*mailText = [[NSString alloc] initWithFormat:@"       %@",_mailRow[row].mailText];
//    NSLog(@"-----   %@",[[_mailRow[row].mailText mutableCopy]copy]);
//    NSLog(@"---%@",[[[_mailRow[row].mailText mutableCopy]copy] class]);
    [_text setString:mailText];
    _text.editable = NO;
    [_subMailView addSubview:_text];
    
    
    
    
    [self.view addSubview:_subMailView];
}

//back事件，remove SubView
-(void)removeSubView
{
    NSLog(@"removeSubView");
    [_subMailView removeFromSuperview];
}

@end
/*
2022-07-15 10:17:21.733505+0800 Mail[80504:20158675] dataDictionary = {
    historyId = 3078;
    id = <4l0j0gq0zkt3-pc5a4onzs59n2y45wh8ngdzwm1lxk6-u296504m7tc4-mwsog1-qeabcakc1v0s-gupxcbt9nzcr-xecvma-2h6c0l-oyn4fpcq5aph-v4pw3w7toi5b-ecsliq-8kz9d0ozuq8o-mft60d.1657846027627@email.android.com>;
    internalDate = 1657846027000;
    labelIds =     (
        UNREAD,
        IMPORTANT,
        "CATEGORY_PERSONAL",
        INBOX
    );
    payload =     {
        body =         {
            data = "5rWL6K-VNuWPtzxicj48YnI-PGRpdiBpZD0iaHdfc2lnbmF0dXJlIj7lj5Hoh6rmiJHnmoTojaPogIDmiYvmnLo8L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPjxicj48YnI-LS0tLS0tLS0g5Y6f5aeL6YKu5Lu2IC0tLS0tLS0tPGJyPuWPkeS7tuS6uu-8miByc3QxMjA0OTcwNTU2QG1haWwudXN0Yy5lZHUuY248YnI-5pel5pyf77yaIDIwMjLlubQ35pyIMTXml6XlkajkupQgMDg6NDc8YnI-5pS25Lu25Lq677yaIHNodXRpYW5ydWFuMDBAZ21haWwuY29tPGJyPuS4uyAgICDpopjvvJog5Zue5aSN77ya5oiR5piv5Li76aKYPGJyPjxibG9ja3F1b3RlPua1i-ivlTXlj7c8YnI-PGJyPjxkaXYgaWQ9Imh3X3NpZ25hdHVyZSI-5Y-R6Ieq5oiR55qE6I2j6ICA5omL5py6PC9kaXY-PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41Ij48YnI-PGJyPi0tLS0tLS0tIOWOn-Wni-mCruS7tiAtLS0tLS0tLTxicj7lj5Hku7bkurrvvJogcnN0MTIwNDk3MDU1NkBtYWlsLnVzdGMuZWR1LmNuPGJyPuaXpeacn--8miAyMDIy5bm0N-aciDE15pel5ZGo5LqUIDA4OjQ2PGJyPuaUtuS7tuS6uu-8miBzaHV0aWFucnVhbjAwQGdtYWlsLmNvbTxicj7kuLsgICAg6aKY77yaIOWbnuWkje-8muaIkeaYr-S4u-mimDxicj48YmxvY2txdW90ZT7mtYvor5U05Y-3PGJyPjxicj48ZGl2IGlkPSJod19zaWduYXR1cmUiPuWPkeiHquaIkeeahOiNo-iAgOaJi-acujwvZGl2PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI-PGJyPjxicj4tLS0tLS0tLSDljp_lp4vpgq7ku7YgLS0tLS0tLS08YnI-5Y-R5Lu25Lq677yaIHJzdDEyMDQ5NzA1NTZAbWFpbC51c3RjLmVkdS5jbjxicj7ml6XmnJ_vvJogMjAyMuW5tDfmnIgxNeaXpeWRqOS6lCAwODo0Njxicj7mlLbku7bkurrvvJogc2h1dGlhbnJ1YW4wMEBnbWFpbC5jb208YnI-5Li7ICAgIOmimO-8miDlm57lpI3vvJrmiJHmmK_kuLvpopg8YnI-PGJsb2NrcXVvdGU-5rWL6K-V5LiJ5Y-3PGJyPjxicj48ZGl2IGlkPSJod19zaWduYXR1cmUiPuWPkeiHquaIkeeahOiNo-iAgOaJi-acujwvZGl2PjxkaXYgc3R5bGU9ImxpbmUtaGVpZ2h0OjEuNSI-PGJyPjxicj4tLS0tLS0tLSDljp_lp4vpgq7ku7YgLS0tLS0tLS08YnI-5Y-R5Lu25Lq677yaIHJzdDEyMDQ5NzA1NTZAbWFpbC51c3RjLmVkdS5jbjxicj7ml6XmnJ_vvJogMjAyMuW5tDfmnIgxNeaXpeWRqOS6lCAwODo0Njxicj7mlLbku7bkurrvvJogc2h1dGlhbnJ1YW4wMEBnbWFpbC5jb208YnI-5Li7ICAgIOmimO-8miDlm57lpI3vvJrmiJHmmK_kuLvpopg8YnI-PGJsb2NrcXVvdGU-5oiR5piv5rWL6K-VMuWPtzxicj48YnI-PGRpdiBpZD0iaHdfc2lnbmF0dXJlIj7lj5Hoh6rmiJHnmoTojaPogIDmiYvmnLo8L2Rpdj48ZGl2IHN0eWxlPSJsaW5lLWhlaWdodDoxLjUiPjxicj48YnI-LS0tLS0tLS0g5Y6f5aeL6YKu5Lu2IC0tLS0tLS0tPGJyPuWPkeS7tuS6uu-8miByc3QxMjA0OTcwNTU2QG1haWwudXN0Yy5lZHUuY248YnI-5pel5pyf77yaIDIwMjLlubQ35pyIMTTml6Xlkajlm5sgMTY6MTA8YnI-5pS25Lu25Lq677yaIHNodXRpYW5ydWFuMDBAZ21haWwuY29tPGJyPuS4uyAgICDpopjvvJog5Zue5aSN77ya5oiR5piv5Li76aKYPGJyPjxibG9ja3F1b3RlPuaIkeaYr-ato-aWhyYjeGZmMGM75rWL6K-VMeWPtzxiciAvPjxiciAvPjxkaXY-5Y-R6Ieq5oiR55qE6I2j6ICA5omL5py6PC9kaXY-PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41Ij48YnIgLz48YnIgLz4tLS0tLS0tLSDljp_lp4vpgq7ku7YgLS0tLS0tLS08YnIgLz7lj5Hku7bkuromI3hmZjFhOyByc3QxMjA0OTcwNTU2JiM2NDttYWlsLnVzdGMuZWR1LmNuPGJyIC8-5pel5pyfJiN4ZmYxYTsgMjAyMuW5tDfmnIgxNOaXpeWRqOWbmyAxNToyNjxiciAvPuaUtuS7tuS6uiYjeGZmMWE7IHNodXRpYW5ydWFuMDAmIzY0O2dtYWlsLmNvbTxiciAvPuS4uyAgICDpopgmI3hmZjFhOyDmiJHmmK_kuLvpopg8YnIgLz48YmxvY2txdW90ZT48ZGl2IGRpcj0iYXV0byI-5oiR5piv5q2j5paHPGJyIC8-PGJyIC8-PGJyIC8-PGJyIC8-PGJyIC8-PGRpdj7lj5Hoh6rmiJHnmoTojaPogIDmiYvmnLo8L2Rpdj48L2Rpdj48L2Jsb2NrcXVvdGU-PC9kaXY-PC9ibG9ja3F1b3RlPjwvZGl2PjwvYmxvY2txdW90ZT48L2Rpdj48L2Jsb2NrcXVvdGU-PC9kaXY-PC9ibG9ja3F1b3RlPjwvZGl2PjwvYmxvY2txdW90ZT48L2Rpdj4=";
            size = 2192;
        };
        filename = "";
        headers =         (
                        {
                name = "Delivered-To";
                value = "shutianruan00@gmail.com";
            },
                        {
                name = Received;
                value = "by 2002:a05:7010:2a9:b0:2e8:4369:26b4 with SMTP id d41csp1258461mdl;        Thu, 14 Jul 2022 17:47:42 -0700 (PDT)";
            },
                        {
                name = "X-Google-Smtp-Source";
                value = "AGRyM1u5YxaORoD12mo9L+5iiy2quVD3dW5etXyVtRTuvdQ9uyQUYXfc8gC4kEmwFYTmbch04cJN";
            },
                        {
                name = "X-Received";
                value = "by 2002:a05:6a00:1c53:b0:528:cdf9:99fb with SMTP id s19-20020a056a001c5300b00528cdf999fbmr10947579pfw.30.1657846062049;        Thu, 14 Jul 2022 17:47:42 -0700 (PDT)";
            },
                        {
                name = "ARC-Seal";
                value = "i=1; a=rsa-sha256; t=1657846062; cv=none;        d=google.com; s=arc-20160816;        b=hxOap1Y88nqhBGRd0XD+RePahLvoA5uWouSREHWmsmho+HdesGhOjCA4nd4xITtjfV         eNwR/PYt7StZf8xQRqF/Q7hmNRr21LunR4RO/gXCUSqY6Y6jmUsmSxJN64nHayPaiSYK         xcSoycPM51qyLTZkR1sY33qadbajQWpKHPWmxKHdzXH5HVgSxkprw2NKe1TtH3/rSzvm         7+DW1cZAxnrwnB3G0eNUIzIUNGkVJW/ukLmuR0PKO5X0yz3IxaZwVZU3S+59U29fHN8/         GHZF7ejjejgHoiYZfI5lDewHyDvl0MNRYcFbMPpf/r0/2ibf8eGFQLcxpwcc9CJOgTP4         kaIg==";
            },
                        {
                name = "ARC-Message-Signature";
                value = "i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;        h=content-transfer-encoding:mime-version:to:from:references         :message-id:subject:date:dkim-signature;        bh=ZXTSni6H795Ap/u/001dZZ07VH/1FmZ4Z9dxbVr6s/0=;        b=Wf72SxZTD5Uw+reuTO9hrxlvM8sykU5RiYwL7pEGH8zJFFjPG2gM0c/8rlq4ddEEKl         jr49wh+AQdId7rW7UNXFTfBeOGEu8+Tw4Jo1mkL15Mpov6iw6TfcxANZ2jliw8c7bHSP         Y+BczlYcb/am1Ejt26jwoLAi8EQ77BYDtVyS8m/5O+TwdrY5vZay3+PmAAbIbxMsnnfc         mccYWytg3C9UgqTAAo/B6Sjzk/+0IwtkwX0EdUsFEm+fPhwyEmlzm09bUHiVyEozmVm0         IDheiklznNAEfZvFtzOtydnpya+i8vkCu5OKwAJr7k3w9Rc1LucgxI1nePMjOjyuyi3Z         IAdA==";
            },
                        {
                name = "ARC-Authentication-Results";
                value = "i=1; mx.google.com;       dkim=pass header.i=@mail.ustc.edu.cn header.s=dkim header.b=HZ2RFJEl;       spf=pass (google.com: domain of rst1204970556@mail.ustc.edu.cn designates 202.38.64.46 as permitted sender) smtp.mailfrom=rst1204970556@mail.ustc.edu.cn;       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=mail.ustc.edu.cn";
            },
                        {
                name = "Return-Path";
                value = "<rst1204970556@mail.ustc.edu.cn>";
            },
                        {
                name = Received;
                value = "from ustc.edu.cn (smtp2.ustc.edu.cn. [202.38.64.46])        by mx.google.com with ESMTP id bb12-20020a17090b008c00b001f051826088si6860776pjb.43.2022.07.14.17.47.41        for <shutianruan00@gmail.com>;        Thu, 14 Jul 2022 17:47:42 -0700 (PDT)";
            },
                        {
                name = "Received-SPF";
                value = "pass (google.com: domain of rst1204970556@mail.ustc.edu.cn designates 202.38.64.46 as permitted sender) client-ip=202.38.64.46;";
            },
                        {
                name = "Authentication-Results";
                value = "mx.google.com;       dkim=pass header.i=@mail.ustc.edu.cn header.s=dkim header.b=HZ2RFJEl;       spf=pass (google.com: domain of rst1204970556@mail.ustc.edu.cn designates 202.38.64.46 as permitted sender) smtp.mailfrom=rst1204970556@mail.ustc.edu.cn;       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=mail.ustc.edu.cn";
            },
                        {
                name = "DKIM-Signature";
                value = "v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.ustc.edu.cn; s=dkim; h=Received:Date:Subject:Message-ID: References:From:To:MIME-Version:Content-Type: Content-Transfer-Encoding; bh=ZXTSni6H795Ap/u/001dZZ07VH/1FmZ4Z9 dxbVr6s/0=; b=HZ2RFJElu/viK6JN8GAEUYrNi8Xz/tN+iaiXc9e6eaqU3IYDZK SNEivrDwWYvaSee7toF9Uq7LDbYuIHsLlxyEkXaWOAHua7/ffHr4BA9A9xv/m/lK Os8DoNQ3PI+M/fjU2OXbk5zv+HRgy89GNnLlyUZMR6fKmpywEd0D8eU5s=";
            },
                        {
                name = Received;
                value = "from [10.33.200.84] (unknown [39.144.34.119]) by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAHElgNudBiPdQHAA--.1319S2; Fri, 15 Jul 2022 08:47:09 +0800 (CST)";
            },
                        {
                name = Date;
                value = "Fri, 15 Jul 2022 08:47:07 +0800";
            },
                        {
                name = Subject;
                value = "\U56de\U590d\Uff1a\U6211\U662f\U4e3b\U9898";
            },
                        {
                name = "X-Priority";
                value = 3;
            },
                        {
                name = "Message-ID";
                value = "<4l0j0gq0zkt3-pc5a4onzs59n2y45wh8ngdzwm1lxk6-u296504m7tc4-mwsog1-qeabcakc1v0s-gupxcbt9nzcr-xecvma-2h6c0l-oyn4fpcq5aph-v4pw3w7toi5b-ecsliq-8kz9d0ozuq8o-mft60d.1657846027627@email.android.com>";
            },
                        {
                name = References;
                value = "<1eber2-cxh9x83qa8w1uryd9o2al6c9s4t9mv-se8hpk-xspdts-yewy66s44fa0sjo4kw-4unxlc-86f25h-mdpc1av13jkhutmask4zpvlt-mqpvo3-2t7zj5avnos3-1wboay-m3s3hq-qpsg8w4e596d.1657785349888@email.android.com> <2vlptw-spc30hsr9991-2esjyn-871b0n6l0kbukx8rdsp84ml-sh9jq9-b7u4up-cxeenrxzlwnxvq2w71-uwbe776klfgi-94h4aj-d9btnf-kz192fcj3wpy-djw68k-lam83r4u2o72-hl3ccg-vgm92h.1657846008847@email.android.com> <5izajt-gyztou-x4icctd9gpz2ndcxoygvovcomlejv1416z32ozreua4lew34-x9pipj7998oz81epv5-fynoag11w3si-zhuyhm7dcdf3-9c2uwg-kr87ir-kgbl6i-6hxt7omf5lu3-b9dhxt-s7b7x.1657846015170@email.android.com> <k6qo2iiyvuajmbwtj-l9y7jyubfw42sqhmcjvy0xdk-ocvm65wqpjqg-jbfo9ok7byocoqh9qc-f3gi6ocsg7hbdx9pe4evku00-2i6uth2ok2s8-y4yij-h9dnei9jsgli-76zjui4rht8t53qqul.1657846019873@email.android.com> <-txemv0l78kjj-h6ozd0-8f1fvh-kwk7kch3u0z2-93xbhh-b6cnx9-qedef171uocj-9vbxn8-u3djgd8zlu82-bd2gjb-dh37ur6gb40x-w0lrvfyx6k6s-sh3rheu275oc8ntp88-3r998e-pkx8ulnhgyxz.1657846024066@email.android.com>";
            },
                        {
                name = From;
                value = "\"rst1204970556@mail.ustc.edu.cn\" <rst1204970556@mail.ustc.edu.cn>";
            },
                        {
                name = To;
                value = "\"shutianruan00@gmail.com\" <shutianruan00@gmail.com>";
            },
                        {
                name = "MIME-Version";
                value = "1.0";
            },
                        {
                name = "Content-Type";
                value = "text/html; charset=utf-8";
            },
                        {
                name = "Content-Transfer-Encoding";
                value = base64;
            },
                        {
                name = "X-CM-TRANSID";
                value = "LkAmygAHElgNudBiPdQHAA--.1319S2";
            },
                        {
                name = "X-Coremail-Antispam";
                value = "1UD129KBjvJXoW7tFW7Aw17Xw4xWF48WF4fAFb_yoW8Xw1Upr nI9347GanFyr4kWry0kw17Kry5GFyjqwsrGw1q9aykXF17C39akFyIqF18WryxJr93Ar1j vFn7WF9rZry5Z3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2 9KBjDU0xBIdaVrnRJUUUHYb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2 0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq 07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r 1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l FcxC0VAYjxAxZF0Ew4CEw7xC0wACY4xI6c02F40Ez4kGawAKzVCjr7xvwVAFz4v204v26I 0v724l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_ Jrv_JF1lx2IqxVAqx4xG67AKxVWUGVWUWwC20s026x8GjcxK67AKxVWUJVWUGwC2zVA082 0Y0xCF62I06xkIj41lx4CE17CEb7AF67AKxVWUJVWUXwCIc40Y0x0EwIxGrwCI42IY6xII jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2 0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02 67AKxVWUJVW8JwCE64xvF2IEb7IF0Fy7YxBIdaVFxhVjvjDU0xZFpf9x07jhpnQUUUUU=";
            },
                        {
                name = "X-CM-SenderInfo";
                value = "puvwijiquzliqvvwqzxdloh3xvwfhvlgxou0/";
            }
        );
        mimeType = "text/html";
        partId = "";
    };
    sizeEstimate = 9284;
    snippet = "\U6d4b\U8bd56\U53f7 \U53d1\U81ea\U6211\U7684\U8363\U8000\U624b\U673a -------- \U539f\U59cb\U90ae\U4ef6 -------- \U53d1\U4ef6\U4eba\Uff1a rst1204970556@mail.ustc.edu.cn \U65e5\U671f\Uff1a 2022\U5e747\U670815\U65e5\U5468\U4e94 08:47 \U6536\U4ef6\U4eba\Uff1a shutianruan00@gmail.com \U4e3b \U9898\Uff1a \U56de\U590d\Uff1a\U6211\U662f\U4e3b\U9898 \U6d4b\U8bd55\U53f7 \U53d1\U81ea\U6211\U7684\U8363\U8000\U624b\U673a -------- \U539f\U59cb\U90ae\U4ef6 -------- \U53d1\U4ef6\U4eba\Uff1a rst1204970556@mail.";
    threadId = 181fb8a579b0112e;
}
*/
