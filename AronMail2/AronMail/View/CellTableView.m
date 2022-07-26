//
//  CellTableView.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//

#import "CellTableView.h"

@implementation CellTableView
- (instancetype)initWithFrame:(NSRect)frameRect {
    self =[super initWithFrame:frameRect];
    if (self) {
        
//        NSImage*image = [NSImage imageNamed:@"updata"];
//        self.jView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
//        [self.jView setImage:image];
//        [self addSubview:self.jView];
        
//        _collectMailButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 40, 16)];
//        _collectMailButton.bordered = NO;
//        _collectMailButton.title = @"collect";
//        [self addSubview:_collectMailButton];
        
        _nameView = [[NSTextField alloc] initWithFrame:CGRectMake(40, 0, 100, 16)];
        _nameView.editable=NO;
        _nameView.selectable=NO;
        _nameView.bordered = NO;
        _nameView.backgroundColor = [NSColor clearColor];
        [self addSubview:_nameView];
        
        _textView = [[NSTextField alloc] initWithFrame:CGRectMake(140, 0, 400, 16)];
        _textView.editable=NO;
        _textView.selectable=NO;
        _textView.bordered=NO;
        _textView.backgroundColor = [NSColor clearColor];
        [self addSubview:_textView];
        
        _timeView = [[NSTextField alloc] initWithFrame:CGRectMake(560, 0, 170, 16)];
        _timeView.editable=NO;
        _timeView.selectable=NO;
        _timeView.bordered = NO;
        _timeView.backgroundColor = [NSColor clearColor];
        [self addSubview:_timeView];
        
//        NSTableColumn*tableColumn = [[NSTableColumn alloc] init];
//        NSTableCellView*tableCellView = [[NSTableCellView alloc] initWithFrame:CGRectMake(600, 0, 150, 20)];
//        [tableCellView addSubview:_timeView];
//        NSTextFieldCell*textfieldCell = [[NSTextFieldCell alloc] init];
//
//        [self addSubview:tableCellView];
        
    }
    return self;
}
- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
//    self.nameView.cell.backgroundStyle = NSBackgroundStyleNormal;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
