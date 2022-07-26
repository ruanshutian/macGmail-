//
//  CellTableView.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellTableView : NSTableCellView
//@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSTextField *nameView;
//@property (nonatomic, strong) NSTextView *mailView;
@property (nonatomic, strong) NSTextField *textView;
@property (nonatomic, strong) NSTextField *timeView;

@property (nonatomic, strong) NSButton *collectMailButton;
@property (nonatomic, strong) NSImageView *jView;

@end

NS_ASSUME_NONNULL_END
