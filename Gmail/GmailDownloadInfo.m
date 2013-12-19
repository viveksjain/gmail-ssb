//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//

#import "GmailDownloadInfo.h"

@implementation GmailDownloadInfo

- (id)copyWithZone:(NSZone *)zone
{
    GmailDownloadInfo *copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.progress = self.progress;
        copy.response = self.response;
        copy.filename = self.filename;
    }
    
    return copy;
}

@end
