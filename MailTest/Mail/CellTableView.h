//
//  CellTableView.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/12.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellTableView : NSView
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSTextView *nameView;
//@property (nonatomic, strong) NSTextView *mailView;
@property (nonatomic, strong) NSImageView *jView;
@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, strong) NSTextView *timeView;

@property (nonatomic, strong) NSButton *collectMailButton;

@end

NS_ASSUME_NONNULL_END
