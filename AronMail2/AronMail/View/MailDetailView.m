//
//  MailDetailView.m
//  Mail
//
//  Created by Aron Ruan on 2022/7/20.
//

#import "MailDetailView.h"

@implementation MailDetailView
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
        _view= [[NSView alloc] initWithFrame:CGRectMake(0, 0, 6*self.frame.size.width/7, self.frame.size.height)];
        [self addSubview:_view];
        [self viewConstraints:_view];
        _view.wantsLayer=YES;
        _view.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        [self mailDetailBackButtonView];
        [self mailDetailHeaderView];
        [self mailDetailViewInit];
        
    }
    return self;
}
-(void)mailDetailViewInit
{
    _mailWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
    [_view addSubview:_mailWebView];
    [_mailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://google.com"]]];
    
    _mailWebView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_mailWebView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mailWebView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_mailWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mailWebView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:200];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_mailWebView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_mailWebView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_mailWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mailWebView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,right,top,bottom];
    [_mailWebView.superview addConstraints:ConstraintsArray];
}
-(void)mailDetailHeaderView
{
    NSInteger h = 20;
    
    _subjectTextButton = [[NSButton alloc] initWithFrame:CGRectMake(50, 0, 100, h)];
    _subjectTextButton.title =@"_subjectTextButton";
    _subjectTextButton.bordered=NO;
    [_view addSubview:_subjectTextButton];
    
    _subjectTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftSubjectTextButton = [NSLayoutConstraint constraintWithItem:_subjectTextButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_subjectTextButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50];
    NSLayoutConstraint *topSubjectTextButton = [NSLayoutConstraint constraintWithItem:_subjectTextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_subjectTextButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:50];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[leftSubjectTextButton,topSubjectTextButton];
    [_subjectTextButton.superview addConstraints:ConstraintsArray];
    
    
    _senderNameTextButton = [[NSButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - h-100, 200, 16)];
    _senderNameTextButton.title =@"_senderNameTextButton";
    _senderNameTextButton.bordered=NO;
    [_view addSubview:_senderNameTextButton];
    _senderNameTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftSenderNameTextButton = [NSLayoutConstraint constraintWithItem:_senderNameTextButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_senderNameTextButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50];
    NSLayoutConstraint *topSenderNameTextButton = [NSLayoutConstraint constraintWithItem:_senderNameTextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_senderNameTextButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:100];
    NSArray<NSLayoutConstraint *>*ConstraintsArraySenderNameTextButton = @[leftSenderNameTextButton,topSenderNameTextButton];
    [_subjectTextButton.superview addConstraints:ConstraintsArraySenderNameTextButton];
    
    _dateTextButton = [[NSButton alloc] initWithFrame:CGRectMake(400, self.view.frame.size.height - h-100, 200, 16)];
    _dateTextButton.title=@"_dateTextButton";
    _dateTextButton.bordered=NO;
    [_view addSubview:_dateTextButton];
    _dateTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left_dateTextButton = [NSLayoutConstraint constraintWithItem:_dateTextButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_dateTextButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:400];
    NSLayoutConstraint *top_dateTextButton = [NSLayoutConstraint constraintWithItem:_dateTextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dateTextButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:120];
    NSArray<NSLayoutConstraint *>*ConstraintsArray_dateTextButton = @[left_dateTextButton,top_dateTextButton];
    [_dateTextButton.superview addConstraints:ConstraintsArray_dateTextButton];
    
    _getNameTextButton = [[NSButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - h-130, 200, 16)];
    _getNameTextButton.title=@"_getNameTextButton";
    _getNameTextButton.bordered = NO;
    [_view addSubview:_getNameTextButton];
    _getNameTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left_getNameTextButton = [NSLayoutConstraint constraintWithItem:_getNameTextButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_getNameTextButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50];
    NSLayoutConstraint *top_getNameTextButton = [NSLayoutConstraint constraintWithItem:_getNameTextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_getNameTextButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:120];
    NSArray<NSLayoutConstraint *>*ConstraintsArray_getNameTextButton = @[left_getNameTextButton,top_getNameTextButton];
    [_dateTextButton.superview addConstraints:ConstraintsArray_getNameTextButton];
    
}
-(void)mailDetailBackButtonView
{
    NSInteger h = 20;
    _backButton = [[NSButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - h-20, 50, h)];
    _backButton.bordered = NO;
    _backButton.title =@"back";
    [_view addSubview:_backButton];
    _backButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_backButton.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_backButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_backButton.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:50];
    NSArray<NSLayoutConstraint *>*ConstraintsArray = @[left,top];
    [_backButton.superview addConstraints:ConstraintsArray];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    

}

@end
