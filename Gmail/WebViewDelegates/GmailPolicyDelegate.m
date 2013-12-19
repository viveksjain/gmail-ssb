//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailPolicyDelegate.h"
#import "GmailUtils.h"

@implementation GmailPolicyDelegate {
    /* Keep track of the app's WebViews so we can decide the navigation action appropriately. */
    NSMutableArray *gmailWebViews;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!gmailWebViews) { // If not already initialized
            gmailWebViews = [NSMutableArray array];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(windowWillClose:)
                                                         name:NSWindowWillCloseNotification
                                                       object:nil];
        }
    }
    return self;
}

/*
 * Ensure that only one instance is ever allocated - this is required since
 * gmailWebViews must be shared between all WebViews.
 */
+ (id)allocWithZone:(NSZone *)zone
{
    static GmailPolicyDelegate *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
        return instance;
    }
}

/*
 * Updates gmailWebViews when a window closed.
 */
- (void)windowWillClose:(NSNotification *)notification
{
    WebView *webView = [GmailUtils getWebView:[notification object]];
    [gmailWebViews removeObject:webView];
}

- (void)webView:(WebView *)sender
decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(WebFrame *)frame
decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if (request == nil) return;
    if ([gmailWebViews containsObject:sender]) {
        [listener use];
    } else if ([[[request URL] host] isEqualToString:@"mail.google.com"]) {
        [gmailWebViews addObject:sender];
        [listener use];
    } else {
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
        [listener ignore];
        [[sender window] close];
    }
}

/*
 * Download everything except HTML pages.
 */
- (void)webView:(WebView *)wv
decidePolicyForMIMEType:(NSString *)type
        request:(NSURLRequest *)req
          frame:(WebFrame *)frame
decisionListener:(id<WebPolicyDecisionListener>)listener
{
    if ([type isEqualToString:@"text/html"]) [listener use];
    else [listener download];
}

@end
