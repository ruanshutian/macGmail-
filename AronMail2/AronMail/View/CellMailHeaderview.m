//
//  CellMailHeaderview.m
//  Mail
//
//  Created by Aron Ruan on 2022/7/20.
//

#import "CellMailHeaderview.h"

@implementation CellMailHeaderview
- (instancetype)initWithFrame:(NSRect)frameRect {
    self =[super initWithFrame:frameRect];
    if (self)
    {
        _lastPageButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
        _nextPageButton = [[NSButton alloc] initWithFrame:CGRectMake(80, 0, 60, 15)];
        _lastPageButton.title=@"last page";
        _nextPageButton.title=@"next page";
//        _lastPageButton.bordered=NO;
//        _nextPageButton.bordered=NO;
        [self addSubview:_lastPageButton];
        [self addSubview:_nextPageButton];
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    

    
    // Drawing code here.
}

@end
