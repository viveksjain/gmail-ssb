//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface GmailApplicationDelegate : NSObject<NSApplicationDelegate>

- (IBAction)showMainWindow:(id)sender;
- (IBAction)loadGmailInMainWindow:(id)sender;

@end
