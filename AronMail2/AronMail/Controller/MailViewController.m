//
//  MailViewController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MailViewController.h"


@interface MailViewController ()<NSTableViewDataSource,NSTableViewDelegate,WKNavigationDelegate,WKUIDelegate,NSSplitViewDelegate>


@end

@implementation MailViewController
//邮件加载数量
NSInteger const LoadMessageNumber = 20;



NSString*html = @"测试27<br><br><div id=\"hw_signature\">发自我的荣耀手机</div><div style=\"line-height:1.5\"><br><br>-------- 原始邮件 --------<br>发件人： rst1204970556@mail.ustc.edu.cn<br>日期： 2022年7月15日周五 18:22<br>收件人： shutianruan00@gmail.com<br>主    题： 回复：我是主题<br><blockquote>测试26<br><br><div id=\"hw_signature\">发自我的荣耀手机</div><div style=\"line-height:1.5\"><br><br>";


//_mailMenuListArray
-(void)mailMenuListArrayInit
{
    if(_mailMenuListArray==nil)
    {
        _mailMenuListArray = [[NSMutableArray alloc] init];
    }
    
    [_mailMenuListArray addObject:@"Login"];
    [_mailMenuListArray addObject:@"Load"];
    [_mailMenuListArray addObject:@"Inbox"];
    [_mailMenuListArray addObject:@"Starred"];
    [_mailMenuListArray addObject:@"Draft"];
    [_mailMenuListArray addObject:@"Outbox"];
    [_mailMenuListArray addObject:@"More"];
    [_mailMenuListArray addObject:@" "];
    [_mailMenuListArray addObject:@"+create new label"];
}
-(void)mailListArrayInit
{
    _mailDataFileNameArray = [[NSMutableArray alloc] init];
    _mailListArray = [[NSMutableArray alloc] init];
    _mailEveryPageArray = [[NSMutableArray alloc] init];
    MailList*temp =[[MailList alloc] init];
    [_mailEveryPageArray addObject:temp];
}
//_mainMailView添加约束
-(void)nsViewConstaint:(NSView*)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [view.superview addConstraints:ConstraintsArray];
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{

    NSLog(@"-- %ld , %f",(long)dividerIndex,proposedMaximumPosition);

       if (dividerIndex == 0) {
           return 500;
       }
        return proposedMaximumPosition;
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
        NSLog(@"-- %ld - %f",dividerIndex,proposedMinimumPosition);
        if (dividerIndex == 0) {
            return 100;
        }
       return proposedMinimumPosition;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    if(_mainMailView==nil)
    {
        _mainMailView = [[MainMailSplitView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    
    [self.view addSubview:_mainMailView];
    [self nsViewConstaint:_mainMailView];
    _mainMailView.delegate =self;

    //数据加载
    [self mailMenuListArrayInit];
    [self mailListArrayInit];
    //delegate
    _mainMailView.leftMenuTableView.delegate = self;
    _mainMailView.leftMenuTableView.dataSource = self;
    _mainMailView.mailListTableView.delegate = self;
    _mainMailView.mailListTableView.dataSource = self;
    [_mainMailView.leftMenuTableView reloadData];
//    [_mainMailView.mailListTableView reloadData];
    _mainMailView.mailHeaderTableView.delegate = self;
    _mainMailView.mailHeaderTableView.dataSource =self;
    [_mainMailView.mailHeaderTableView reloadData];

    //视图显示
    //leftMenu菜单选择
    [_mainMailView.leftMenuTableView setAction:@selector(leftMenuTableViewClick)];

    [self LoadMailDataFileName];
    [self LoadMailDataToArray];
    //Load初始化mailEveryPageView（第一页数据）
    [self mailEveryPageViewInit];

    //MailList选择
    [_mainMailView.mailListTableView setAction:@selector(mailListTableViewClick)];
    
}

//MailList选择事件
-(void)mailListTableViewClick
{
    NSInteger row =[_mainMailView.mailListTableView clickedRow];
    NSLog(@"row =%ld",row);
    if(row<0)
    {
        return;
    }
    [self mailDetailViewInit:row];
}

//Maildeail
-(void)mailDetailViewInit:(NSInteger)row
{
    if(_mailDetailView ==nil)
    {
        _mailDetailView = [[MailDetailView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    }
//    [_mainMailView.rightView addSubview:_mailDetailView];
    [_mainMailView replaceSubview:_mainMailView.rightView with:_mailDetailView];
    
//    [self nsViewConstaint:_mailDetailView];
    
    [_mailDetailView.backButton setAction:@selector(backClick)];
    _mailDetailView.mailWebView.UIDelegate =self;
    _mailDetailView.mailWebView.navigationDelegate =self;
    
//    [_mailDetailView.mailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://google.com"]]];
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    html = _mailEveryPageArray[row].mailText;
    [_mailDetailView.mailWebView loadHTMLString:html baseURL:bundleUrl];
//    NSData *htmlData = [[NSData alloc] initWithBase64EncodedString:@"5rWL6K-VMjE8YnI-PGJyPjxkaXYgaWQ9Imh3X3NpZ25hdHVyZSI-5Y-R6Ieq5oiR55qE6I2j6ICA5omL5py6PC9kaXY-PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41Ij48YnI-PGJyPi0tLS0tLS0tIOWOn-Wni-mCruS7ti" options:0];
//    [_mailDetailView.mailWebView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:bundleUrl];
    
    //
    _mailDetailView.subjectTextButton.title = _mailEveryPageArray[row].mailSubject;
    _mailDetailView.getNameTextButton.title = _mailEveryPageArray[row].mailGetter;
    _mailDetailView.senderNameTextButton.title = _mailEveryPageArray[row].mailSender;
    _mailDetailView.dateTextButton.title =_mailEveryPageArray[row].mailTime;

}

-(void)backClick
{
    NSLog(@"backClick");
    
//    [_mailDetailView removeFromSuperview];
    [_mainMailView replaceSubview:_mailDetailView with:_mainMailView.rightView];
}

//======================
//leftMenu菜单选择事件
-(void)leftMenuTableViewClick
{
    NSInteger row =[_mainMailView.leftMenuTableView clickedRow];
    if(row<0)
    {
        return;
    }
    if([_mailMenuListArray[row] isEqual:@"Login"])
    {
        NSLog(@"row = %ld",row);
//        [_mailRow removeAllObjects];
    }
    else if ([_mailMenuListArray[row] isEqual:@"Load"])
    {
        [_mailListArray removeAllObjects];
        [self LoadClick:_mailDataFileNameArray];
        [self mailEveryPageViewInit];
    }
}







//=============================邮件翻页====================================
-(void)lastPageClick
{
    NSLog(@"lastPageClick");
}
-(void)nextPageClick
{
    NSLog(@"nextPageClick");
    NSInteger index = [_mailListArray indexOfObject:_mailEveryPageArray[LoadMessageNumber-1]];
    [_mailEveryPageArray removeAllObjects];
    for(NSInteger i=0;i<LoadMessageNumber;i++)
    {
        [_mailEveryPageArray addObject:_mailListArray[(index+i+1)%[_mailListArray count]]];
    }
    [_mainMailView.mailListTableView reloadData];
}
-(void)getMailNextPage
{
    [_mailEveryPageArray removeAllObjects];
    MailList*temp =[[MailList alloc] init];
    [_mailEveryPageArray addObject:temp];
    [_mainMailView.mailListTableView reloadData];
}

//=============================获取离线邮件缓存==============================
- (void)LoadMailDataFileName{
    _homePath = NSHomeDirectory();
//    NSLog(@"_homePath根目录:%@", _homePath);
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *mailDataFileNameArr = [manager contentsOfDirectoryAtPath:_homePath error:&error];
    for(NSString* mailDataFileName in mailDataFileNameArr)
    {
        if([mailDataFileName containsString:@".txt"])
        {
            NSLog(@"mailDataFileName = %@",mailDataFileName);
            [_mailDataFileNameArray addObject:mailDataFileName];
        }
    }
}
-(void)LoadMailDataToArray
{
    for(NSString*mailDataFileName in _mailDataFileNameArray)
    {
        [self getEveryRowMailDataFromMailFileName:mailDataFileName];
    }
}
//获取离线邮件初始（条数 = ）

-(void)mailEveryPageViewInit
{
    [_mailEveryPageArray removeAllObjects];
    for(NSInteger i=0;i<LoadMessageNumber;i++)
    {
        [_mailEveryPageArray addObject:_mailListArray[i]];
    }
    [_mainMailView.mailListTableView reloadData];
}

//读取缓存的邮件
-(void)LoadClick:(NSMutableArray*)mailDataFileNameArray
{
    NSLog(@"LoadClick ");
    [self LoadMailDataToArray];
//    NSLog(@"mailDataFileNameArray =%@",mailDataFileNameArray);
//    NSLog(@"_mailListArray =%@",_mailListArray);

}
-(void)getEveryRowMailDataFromMailFileName:(NSString*)mailDataFileName
{
    NSError *error;
    NSString*path = [[NSString alloc] initWithFormat:@"%@/%@",_homePath,mailDataFileName];
    NSString *str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData

                                                            options:NSJSONReadingMutableContainers

                                                              error:&error];
    
    NSString*mailBody =dataDictionary[@"payload"][@"body"][@"data"] ;
    NSLog(@"mail.mailBody = %@",mailBody);
    
    NSString *string = @"测试27<br><br><div id=hw_signature>发自我的荣耀手机</div><div style=line-height:1.5><br><br>-------- 原始邮件 --------<br>发件人： rst1204970556@mail.ustc.edu.cn<br>日期： 2022年7月15日周五 18:22<br>收件人： shutianruan00@gmail.com<br>主    题： 回复：我是主题<br><blockquote>测试26<br><br><div id=hw_signature>发自我的荣耀手机</div><div style=line-height:1.5><br><br>-------- 原始邮件 --------<br>发件人： rst1204970556@mail.ustc.edu.cn<br>日期： 2022年7月15日周五 18:22<br>收件人： shutianruan00@gmail.com<br>主    题： 回复：我是主题<br><blockquote>";
    NSLog(@"原文 - %@", string);
    NSData *mailBodyData =dataDictionary[@"payload"][@"body"][@"data"];
    NSData *data1 = [string dataUsingEncoding: NSUTF8StringEncoding];
    NSString *dataTest2 = [GTMBase64 stringByEncodingData:data1];
    NSString *base64String =[data1 base64EncodedStringWithOptions:0];
    NSLog(@"Base64编码 - %@", base64String);
    NSString*ok = @"5rWL6K-VMjc8YnI-PGJyPjxkaXYgaWQ9Imh3X3NpZ25hdHVyZSI-5Y-R6Ieq5oiR55qE6I2j6ICA5omL5py6PC9kaXY-PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS41Ij";
//    NSString*ok2 = [mailBody stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    NSData *okData = [[NSData alloc]initWithBase64EncodedString:ok options:0];
    NSString *decodeString2 = [[NSString alloc]initWithData:okData encoding: NSUTF8StringEncoding];

    NSLog(@"Base64解码 - %@", decodeString2);

    ///
    
    MailList *mail = [[MailList alloc] init];
    NSMutableArray*headerArray = dataDictionary[@"payload"][@"headers"];
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

    [self->_mailListArray addObject:mail];


    dispatch_async(dispatch_get_main_queue(), ^{

        [self->_mainMailView.mailListTableView reloadData];
    });

}


#pragma mark - NSTableViewDelegate

//- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSDictionary *rowInfoDic = self.dataSource[row];
//    NSString *dataString = rowInfoDic[tableColumn.identifier];
//
//    CustomTableCellView *contentView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
//    if (!contentView) {
//        contentView = [[CustomTableCellView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    }
//    contentView.string = dataString;
//
//    return contentView;
//}

//自定义 row view
//- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
//    CustomTableRowView *rowView = [tableView makeViewWithIdentifier:@"rowView" owner:self];
//    if (rowView == nil) {
//        rowView = [[CustomTableRowView alloc] init];
//        rowView.identifier = @"rowView";
//    }
//    return rowView;
//}

#pragma mark - NSTableViewDataSource
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    return self.dataSource.count;
//}

#pragma mark ***** Notifications *****

//- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//
//    NSTableView *tableView = notification.object;
//    NSLog(@"---selection row %ld", tableView.selectedRow);
////    CustomTableCellView *contentView = [tableView makeViewWithIdentifier:@"name" owner:self];
//
//    CustomTableCellView *contentView = [tableView viewAtColumn:0 row:tableView.selectedRow makeIfNecessary:NO];
//    contentView.label.wantsLayer = YES;
//    contentView.label.textColor = [NSColor blueColor];
//}

//加载tableview
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if([tableView.identifier isEqual:@"leftMenuTableView"])
    {
        return _mailMenuListArray.count;
    }
    else if ([tableView.identifier isEqual:@"mailListTableView"])
    {
        return _mailEveryPageArray.count ;
    }
    else if ([tableView.identifier isEqual:@"mailHeaderTableView"])
    {
        return 1;
    }
    return _mailListArray.count ;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if([tableView.identifier isEqual:@"leftMenuTableView"])
    {
        return _mailMenuListArray[row];
    }
    else if ([tableView.identifier isEqual:@"mailListTableView"])
    {
        return _mailEveryPageArray[row];
    }
    else if ([tableView.identifier isEqual:@"mailHeaderTableView"])
    {
        return _mailMenuListArray[row];
    }
    
    return _mailListArray[row];
}

//- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
//{
//
//}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row API_AVAILABLE(macos(10.7)) {
    if([tableView.identifier isEqual:@"leftMenuTableView"])
    {
        _cellMailMenuListView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        if(!_cellMailMenuListView)
        {
            _cellMailMenuListView = [[CellMailMenuListView alloc] init];
        }
        _cellMailMenuListView.textField.stringValue=_mailMenuListArray[row];
        return _cellMailMenuListView;
    }
    else if ([tableView.identifier isEqual:@"mailListTableView"])
    {
        CellTableView *mailListRowView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        if(!mailListRowView)
        {
            mailListRowView = [[CellTableView alloc] init];
        }
        MailList*mail = [_mailEveryPageArray objectAtIndex:row];
        mailListRowView.nameView.stringValue = mail.mailName;
        mailListRowView.textView.stringValue = mail.mailText;
        mailListRowView.timeView.stringValue = mail.mailTime;
        
        if(row==_mailEveryPageArray.count-1)
        {
//            [self getMailNextPage];
        }
        return mailListRowView;
    }//mailHeaderTableView
    else if ([tableView.identifier isEqual:@"mailHeaderTableView"])
    {
        CellMailHeaderview*cellMailHeaderview = [[CellMailHeaderview alloc] init];
        [cellMailHeaderview.lastPageButton setAction:@selector(lastPageClick)];
        [cellMailHeaderview.nextPageButton setAction:@selector(nextPageClick)];
        return cellMailHeaderview;
    }
    return nil;
}



@end
