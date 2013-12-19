//
//  GmailUtils.h
//  Gmail
//
//  Created by Vivek Jain on 12/19/13.
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface GmailUtils : NSObject

/*
 * Returns the WebView corresponding to the given window.
 */
+ (WebView *)getWebView:(id)window;

/*
 * Returns the main (i.e. the first) window.
 */
+ (id)getMainWindow;

/*
 * Returns the WebView corresponding to the main window.
 */
+ (WebView *)getMainWebView;

@end
