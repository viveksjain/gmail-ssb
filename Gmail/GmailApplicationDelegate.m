//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailApplicationDelegate.h"
#import "PFMoveApplication.h"
#import "GmailDownloadInfo.h"
#import "GmailPolicyDelegate.h"
#import "GmailUtils.h"

@implementation GmailApplicationDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    PFMoveToApplicationsFolderIfNecessary();
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Listen for mailto links (which we declared as a URL we can handle in the Info.plist
    [[NSAppleEventManager sharedAppleEventManager]
     setEventHandler: self
     andSelector: @selector(getUrl:)
     forEventClass: kInternetEventClass
     andEventID: kAEGetURL];
    if ([[[NSApplication sharedApplication] windows] count] == 0) {
        [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
    }
}

/*
 * Handle a mailto link.
 */
- (void)getUrl:(NSAppleEventDescriptor *)event
{
	NSString *url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    url = [self urlEncode:url];
    url = [NSString stringWithFormat:@"https://mail.google.com/mail?extsrc=mailto&url=%@", url];
    
    id myDocument = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
    [[[myDocument webView] mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

/*
 * URL encode a given string. From http://stackoverflow.com/a/8088484
 */
- (NSString *)urlEncode:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

/*
 * If the only window of this application is the main window and it isn't
 * visible, this method makes it frontmost.
 */
- (void)activate
{
    NSArray *windows = [[NSApplication sharedApplication] windows];
    id mainWindow = [GmailUtils getMainWindow];
    if (![mainWindow isVisible] && [windows count] == 1) [mainWindow makeKeyAndOrderFront:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
    [self activate];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [self activate];
    return NO;
}

@end
