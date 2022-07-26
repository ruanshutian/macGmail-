//
//  MailViewController.h
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import <Cocoa/Cocoa.h>
#import "MainMailView.h"
#import "CellTableView.h"
#import "MailList.h"
#import "CellMailMenuListView.h"

#import "CellMailHeaderview.h"

#import "MailDetailView.h"

#import "GTMBase64.h"

#import "MainMailSplitView.h"

#import "CustomTableCellView.h"
#import "CustomTableRowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MailViewController : NSViewController

@property(nonatomic)MainMailSplitView *mainMailView;

//@property(nonatomic)MainMailView*mainMailView;

//@property(weak)IBOutlet NSTableView*tableview;
@property(nonatomic)CellMailMenuListView*cellMailMenuListView;
@property(nonatomic)NSString *homePath;
@property(nonatomic)NSMutableArray*mailDataFileNameArray;

@property(nonatomic)NSMutableArray<NSString*>*mailMenuListArray;
@property(nonatomic)NSMutableArray<MailList*>*mailListArray;

@property(nonatomic)NSMutableArray<MailList*>*mailEveryPageArray;

@property(nonatomic)MailDetailView*mailDetailView;
@end

NS_ASSUME_NONNULL_END
