//
//  MainMailSplitView.h
//  Mail
//
//  Created by Aron Ruan on 2022/7/21.
//

#import <Cocoa/Cocoa.h>
#import "MainMailView.h"
#import "CellMailHeaderview.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainMailSplitView : NSSplitView
@property(nonatomic ) NSView*leftView;
@property(nonatomic ) NSView*rightView;

@property(nonatomic)NSView*mailListView;
@property(nonatomic)NSTableView*leftMenuTableView;
@property(nonatomic)NSTableView*mailListTableView;
@property(nonatomic)NSTableView*mailHeaderTableView;
@property(nonatomic)NSView*mailHeaderView;
@end

NS_ASSUME_NONNULL_END
