//
//  MainMailView.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MainMailView.h"

@implementation MainMailView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        _leftMenuTableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height)];
        _leftMenuTableView.identifier = @"leftMenuTableView";
        
        _mailListTableView = [[NSTableView alloc] initWithFrame:CGRectMake(self.frame.size.width/3, 0, 2*self.frame.size.width/3, self.frame.size.height)];
        _mailListTableView.identifier =@"mailListTableView";
        

        [self leftMenuViewInit];

        [self mailListViewInit];

    }
    return self;
}
-(void)leftMenuViewInit
{
    _leftMenuTableView.headerView.frame = CGRectZero;
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height);
    [self addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    column.width = scrollView.frame.size.width;
    [_leftMenuTableView addTableColumn:column];
    scrollView.contentView.documentView = _leftMenuTableView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:scrollView.frame.size.width];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [scrollView.superview addConstraints:ConstraintsArray];
}
-(void)mailListViewInit
{
    _mailListTableView.headerView.frame = CGRectZero;
    NSScrollView * scrollView    = [[NSScrollView alloc] init];
    scrollView.hasVerticalScroller  = YES;
    scrollView.frame = CGRectMake(self.frame.size.width/3, 0, 2*self.frame.size.width/3, self.frame.size.height);
    [self addSubview:scrollView];
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"test"];
    column.width = scrollView.frame.size.width;
    [_mailListTableView addTableColumn:column];
    scrollView.contentView.documentView = _mailListTableView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:scrollView.frame.size.width/3];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scrollView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [scrollView.superview addConstraints:ConstraintsArray];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.

}

@end
