//
//  AppDelegate.h
//  Mail
//
//  Created by Aron Ruan on 2022/7/13.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@end

