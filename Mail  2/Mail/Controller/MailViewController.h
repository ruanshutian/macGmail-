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
NS_ASSUME_NONNULL_BEGIN

@interface MailViewController : NSViewController
@property(nonatomic)MainMailView*mainMailView;
//@property(weak)IBOutlet NSTableView*tableview;
@property(nonatomic)CellMailMenuListView*cellMailMenuListView;
@end

NS_ASSUME_NONNULL_END
