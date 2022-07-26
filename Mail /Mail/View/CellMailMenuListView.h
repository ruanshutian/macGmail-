//
//  CellMailMenuListView.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/19.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellMailMenuListView : NSView
@property(nonatomic)NSTableCellView*mailMenuRowView;
@property(nonatomic)NSTextField*textField;
@end

NS_ASSUME_NONNULL_END
