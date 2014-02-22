//
//  GmailUtils.m
//  Gmail
//
//  Created by Vivek Jain on 12/19/13.
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailUtils.h"

@implementation GmailUtils

+ (WebView *)getWebView:(id)window
{
    return [[[window contentView] subviews] objectAtIndex:0];
}

+ (WebView *)getMainWebView
{
    return [GmailUtils getWebView:[self getMainWindow]];
}

+ (id)getMainWindow
{
    return [[[NSApplication sharedApplication] windows] objectAtIndex:0];
}

@end
