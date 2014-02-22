//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailDownloadDelegate.h"
#import <WebKit/WebKit.h>
#import "GmailDownloadInfo.h"

@implementation GmailDownloadDelegate {
    NSMapTable *downloads;
}

- (id)init
{
    self = [super init];
    if (self && NSClassFromString(@"NSProgress")) {
        downloads = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString *downloadDir = [NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationFilename = [downloadDir stringByAppendingPathComponent:filename];
    [download setDestination:destinationFilename allowOverwrite:NO];
}

-(void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    if (downloads) {
        NSURL *downloadUrl = [NSURL fileURLWithPath:path];
        GmailDownloadInfo *info = [downloads objectForKey:download];
        [info setFilename:path];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  NSProgressFileOperationKindDownloading,
                                      NSProgressFileOperationKindKey,
                                  nil];
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:0];
        progress = [progress initWithParent:nil userInfo:userInfo];
        [progress setKind:NSProgressKindFile];
        [progress setUserInfoObject:downloadUrl forKey:NSProgressFileURLKey];
        [progress publish];
        [info setProgress:progress];
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    if (downloads) {
        GmailDownloadInfo *info = [[GmailDownloadInfo alloc] init];
        [info setResponse:response];
        [downloads setObject:info forKey:download];
    }
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(unsigned)length {
    if (downloads) {
        GmailDownloadInfo *info = [downloads objectForKey:download];
        long long expectedLength = [[info response] expectedContentLength];
        int64_t completed = [[info progress] completedUnitCount];
        [[info progress] setCompletedUnitCount:(completed + length)];
        if (expectedLength != NSURLResponseUnknownLength) [[info progress] setTotalUnitCount:expectedLength];
    }
}

- (void)downloadDidFinish:(NSURLDownload *)download {
    if (downloads) {
        GmailDownloadInfo *info = [downloads objectForKey:download];
        [[info progress] unpublish];
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.DownloadFileFinished" object:[info filename]];
        [downloads removeObjectForKey:download];
    }
}

@end
