//
//  MailViewController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MailViewController.h"


@interface MailViewController ()<NSTableViewDataSource,NSTableViewDelegate>
@property(nonatomic)NSMutableArray<NSString*>*mailMenuListArray;
@property(nonatomic)NSMutableArray<MailList*>*mailListArray;
@end

@implementation MailViewController

//_mailMenuListArray
-(void)mailMenuListArrayInit
{
    _mailMenuListArray = [[NSMutableArray alloc] init];
    [_mailMenuListArray addObject:@"Login"];
    [_mailMenuListArray addObject:@"Load"];
    [_mailMenuListArray addObject:@"Inbox"];
    [_mailMenuListArray addObject:@"Starred"];
    [_mailMenuListArray addObject:@"Draft"];
    [_mailMenuListArray addObject:@"Outbox"];
    [_mailMenuListArray addObject:@"More"];
    [_mailMenuListArray addObject:@" "];
    [_mailMenuListArray addObject:@"+ create new label"];
}
-(void)mailListArrayInit
{
    _mailListArray = [[NSMutableArray alloc] init];
    MailList*temp = [[MailList alloc] init];
    temp.mailName=@"name";
    temp.mailText=@"text";
    temp.mailTime=@"time";
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    [_mailListArray addObject:temp];
    for(NSInteger i =0 ;i<40;i++)
    {
        [_mailListArray addObject:temp];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //数据加载
    [self mailMenuListArrayInit];
    [self mailListArrayInit];
    
    
    _mainMailView = [[MainMailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _mainMailView = [[MainMailView alloc] init];

    [self.view addSubview:_mainMailView];
    _mainMailView.leftMenuTableView.delegate = self;
    _mainMailView.leftMenuTableView.dataSource = self;
    _mainMailView.mailListTableView.delegate = self;
    _mainMailView.mailListTableView.dataSource = self;
    [_mainMailView.leftMenuTableView reloadData];
    [_mainMailView.mailListTableView reloadData];
    
    [self nsViewConstaint:_mainMailView];
    
    [_mainMailView.leftMenuTableView setAction:@selector(leftMenuTableViewClick)];
    
}
-(void)leftMenuTableViewClick
{
    NSLog(@"leftMenuTableViewClick");
}
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

//加载tableview
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    if([tableView.identifier isEqual:@"leftMenuTableView"])
    {
        return _mailMenuListArray.count;
    }
    else if ([tableView.identifier isEqual:@"mailListTableView"])
    {
        return _mailListArray.count ;
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
        return _mailListArray[row];
    }
    
    return _mailListArray[row];
}
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row API_AVAILABLE(macos(10.7)) {
    if([tableView.identifier isEqual:@"leftMenuTableView"])
    {
        _cellMailMenuListView = [[CellMailMenuListView alloc] init];
        _cellMailMenuListView.textField.stringValue=_mailMenuListArray[row];
        return _cellMailMenuListView;
    }
    else if ([tableView.identifier isEqual:@"mailListTableView"])
    {
        CellTableView *mailListRowView = [[CellTableView alloc] init];
        MailList*mail = [_mailListArray objectAtIndex:row];
        mailListRowView.nameView.string = mail.mailName;
        mailListRowView.textView.string = mail.mailText;
        mailListRowView.timeView.string = mail.mailTime;
        return mailListRowView;
    }
    return nil;
}

//- (void)performClickOnCellAtColumn:(NSInteger)column row:(NSInteger)row  API_DEPRECATED("Use a View Based TableView; directly interact with a particular view as required and call -performClick: on it, if necessary", macos(10.6,10.10))
//{
//    NSLog(@"performClickOnCellAtColumn");
//}
//- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
//{
//    NSLog(@"didClickTableColumn");
//}


@end
