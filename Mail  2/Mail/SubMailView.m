//
//  SubMailView.m
//  Mail
//
//  Created by Aron Ruan on 2022/7/15.
//

#import "SubMailView.h"

@interface SubMailView ()

@end

@implementation SubMailView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self =[super initWithFrame:frameRect];
    if (self) {
//        NSView*subView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        NSTextView*textView = [[NSTextView alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
        textView.backgroundColor = [NSColor blackColor];
        [self addSubview:textView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}



@end
