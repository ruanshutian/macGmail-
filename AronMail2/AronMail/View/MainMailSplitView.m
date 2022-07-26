//
//  MainMailSplitView.m
//  Mail
//
//  Created by Aron Ruan on 2022/7/21.
//

#import "MainMailSplitView.h"

@implementation MainMailSplitView
-(void)viewConstraints:(NSView*)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [view.superview addConstraints:ConstraintsArray];
}
- (instancetype)initWithFrame:(NSRect)frameRect {
    self =[super initWithFrame:frameRect];
    if (self)
    {
        [self MainMailSplitViewInit];

        if(_leftMenuTableView ==nil)
        {
            _leftMenuTableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/7, self.frame.size.height)];
            _leftMenuTableView.identifier = @"leftMenuTableView";
        }
        [self leftMenuViewInit];
        [self viewConstraints:_leftMenuTableView];

        _mailListTableView = [[NSTableView alloc] initWithFrame:CGRectMake(self.frame.size.width/7, 0, 6*self.frame.size.width/7, self.frame.size.height-50)];
        _mailListTableView.identifier =@"mailListTableView";
        [self mailListViewInit];


        _mailHeaderTableView=[[NSTableView alloc] initWithFrame:CGRectMake(self.frame.size.width/7, self.frame.size.height -16, 6*self.frame.size.width/7, 16)];
        _mailHeaderTableView.identifier =@"mailHeaderTableView";
        [self mailHeaderInit];
        
    }
    return self;
}

-(void)MainMailSplitViewInit
{
    self.autoresizingMask =YES;
    [self setVertical:YES];
    [self setDividerStyle:NSSplitViewDividerStyleThin];
    
    CGRect leftRect = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width/7, self.frame.size.height );
    CGRect rightRect = NSMakeRect(self.frame.origin.x, self.frame.origin.y, 6*self.frame.size.width/7, self.frame.size.height );
    if(_leftView ==nil)
    {
        _leftView = [[NSView alloc] initWithFrame:leftRect];
    }
    _leftView.autoresizingMask =0;
    _leftView.autoresizingMask = YES;
    [_leftView setAutoresizesSubviews:YES];
    if(_rightView==nil)
    {
        _rightView = [[NSView alloc]initWithFrame:rightRect];
    }
    _rightView.autoresizingMask =0;
    _rightView.autoresizingMask =YES;
    [_rightView setAutoresizesSubviews:YES];
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    
//    [self viewConstraints:_rightView];
//    [self viewConstraints:_leftView];
    
}

-(void)leftMenuViewInit
{
    _leftMenuTableView.headerView.frame = CGRectZero;
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = CGRectMake(0, 0, self.frame.size.width/7, self.frame.size.height);
    [_leftView addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    column.width = scrollView.frame.size.width;
    [_leftMenuTableView addTableColumn:column];
    scrollView.contentView.documentView = _leftMenuTableView;
    [self viewConstraints:scrollView];
    
}
-(void)mailHeaderInit
{
    _mailHeaderTableView.headerView.frame = CGRectZero;
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = CGRectMake(self.frame.size.width/7, self.frame.size.height-16, 6*self.frame.size.width/7, 16);
    [_rightView addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    column.width = scrollView.frame.size.width;
    [_mailHeaderTableView addTableColumn:column];
    scrollView.contentView.documentView = _mailHeaderTableView;
    
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mailListTableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [scrollView.superview addConstraints:ConstraintsArray];
    
    _mailHeaderTableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:_mailHeaderTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mailHeaderTableView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:_mailHeaderTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mailHeaderTableView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right2 = [NSLayoutConstraint constraintWithItem:_mailHeaderTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_mailHeaderTableView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom2 = [NSLayoutConstraint constraintWithItem:_mailHeaderTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mailHeaderTableView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray2 = @[left2,right2,top2,bottom2];
    [_mailHeaderTableView.superview addConstraints:ConstraintsArray2 ];
    

    
}
-(void)mailListViewInit
{
    _mailListTableView.headerView.frame = CGRectZero;
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = CGRectMake(0, 0, 100, self.frame.size.height-50);
    [_rightView addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    column.width = scrollView.frame.size.width;
    [_mailListTableView addTableColumn:column];
    scrollView.contentView.documentView = _mailListTableView;
//    [self viewConstraints:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:50];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [scrollView.superview addConstraints:ConstraintsArray];
    
    _mailListTableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:_mailListTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mailListTableView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:_mailListTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mailListTableView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right2 = [NSLayoutConstraint constraintWithItem:_mailListTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_mailListTableView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom2 = [NSLayoutConstraint constraintWithItem:_mailListTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mailListTableView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray2 = @[left2,right2,top2,bottom2];
    [_mailListTableView.superview addConstraints:ConstraintsArray2 ];
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
