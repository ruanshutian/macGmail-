//
//  MainLoginView.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MainLoginView.h"

@implementation MainLoginView
- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
//        CGRect*buttonRect = CGRectMake(0, 0, 100, 100);
        _loginButton = [[NSButton alloc] initWithFrame:CGRectMake(frameRect.size.width/2-25, frameRect.size.height/4, 50, 20)];
        _loginButton.title =@"login";
        [self addSubview:_loginButton];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
