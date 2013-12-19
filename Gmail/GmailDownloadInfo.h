//
//  Copyright (c) 2013 Vivek Jain. All rights reserved.
//
//  A wrapper class for storing all the information relevant to a particular download.
//

#import <Foundation/Foundation.h>

@interface GmailDownloadInfo : NSObject<NSCopying>

@property NSProgress *progress;
@property NSURLResponse *response;
@property NSString *filename;

- (id)copyWithZone:(NSZone *)zone;

@end
