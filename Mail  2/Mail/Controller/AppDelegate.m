//
//  AppDelegate.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "AppDelegate.h"
#import "MainWindowsController.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property(nonatomic)MainWindowsController*mainWindowsController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _mainWindowsController = [[MainWindowsController alloc] init];
    [_mainWindowsController showWindow:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [_mainWindowsController showWindow:self];
    return YES;
}

@end
