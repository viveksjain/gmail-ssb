//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailUIDelegate.h"
#import <WebKit/WebKit.h>
#import "GmailApplicationDelegate.h"
#import "GmailDocument.h"
#import "GmailUtils.h"

@implementation GmailUIDelegate

/*
 * Ensure that only one instance is ever allocated - otherwise when a window is
 * closed a message is sent to the delegate's instance after it is deallocated.
 */
+ (id)allocWithZone:(NSZone *)zone
{
    static GmailUIDelegate *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
        return instance;
    }
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    id myDocument = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
    [[[myDocument webView] mainFrame] loadRequest:request];
    return [myDocument webView];
}

/*
 * Show hovered links in the status label.
 */
- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags {
    NSURL *URL = [elementInformation valueForKey:WebElementLinkURLKey];
    
    GmailDocument *document = [[[sender window] windowController] document];
    if (URL) {
        [document setStatusLabel:[URL absoluteString]];
    } else {
        [document setStatusLabel:@""];
    }
}


@end
