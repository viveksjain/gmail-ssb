//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailDocument.h"
#import "GmailApplicationDelegate.h"
#import "GmailPolicyDelegate.h"
#import "GmailUtils.h"
#import "GmailNotificationProvider.h"

@implementation GmailDocument {
    NotificationProvider *notificationProvider;
}

@synthesize webView;

- (NSString *)windowNibName
{
    return @"GmailDocument";
}

- (NSString *)displayName
{
    return @"Gmail";
}

- (BOOL)isDocumentEdited
{
    return NO;
}

/*
 * Hide the main window when it is closed, instead of actually closing it, so
 * that Gmail keeps running in the background.
 */
- (BOOL)windowShouldClose:(id)sender
{
    if (sender == [GmailUtils getMainWindow]) {
        [sender orderOut:nil];
        return NO;
    } else {
        return YES;
    }
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    NSWindow *window = [webView window];
    [window setRestorable:NO];
    
    NSArray *windows = [[NSApplication sharedApplication] windows];
    if ([windows count] == 1) {
        // Only autosave size of the first window
        [window setFrameAutosaveName:@"Gmail"];
        [window setAnimationBehavior:NSWindowAnimationBehaviorNone];
        [webView setMainFrameURL:@"https://mail.google.com/"];
    }
    
    // Set user agent to same as Safari, to make Gmail support drag-and-drop attachments
    [webView setCustomUserAgent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71"];
    
    // Add custom stylesheet that makes sure To and From fields are always
    // visible when composing
    WebPreferences *prefs = [webView preferences];
    [prefs setUserStyleSheetEnabled:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    [prefs setUserStyleSheetLocation:[NSURL fileURLWithPath:path]];
    
    [webView _setNotificationProvider:[NotificationProvider sharedNotificationProvider]];
}

- (void)setStatusLabel:(NSString *)status
{
    [self.status setStringValue:status];
}

@end
