//
//  MainMailView.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainMailView : NSView
//@property(nonatomic)NSView*leftMenuView;
@property(nonatomic)NSView*mailListView;
@property(nonatomic)NSTableView*leftMenuTableView;
@property(nonatomic)NSTableView*mailListTableView;

@end

NS_ASSUME_NONNULL_END
