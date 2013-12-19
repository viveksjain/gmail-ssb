//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface GmailDocument : NSDocument

@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSTextField *status;

/*
 * Set the status label at the bottom of this document.
 */
- (void)setStatusLabel:(NSString *)status;

@end
