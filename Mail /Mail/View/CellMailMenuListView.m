//
//  CellMailMenuListView.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/19.
//

#import "CellMailMenuListView.h"

@implementation CellMailMenuListView
- (instancetype)initWithFrame:(NSRect)frameRect {
    self =[super initWithFrame:frameRect];
    if (self)
    {
        _mailMenuRowView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _textField.bordered = NO;
        _textField.editable = NO;
        _textField.backgroundColor = [NSColor clearColor];
        [_mailMenuRowView addSubview:_textField];
        [self addSubview:_mailMenuRowView];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.

}

@end
