//
//  DAVResponseItem.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@interface DAVResponseItem : NSObject {
  @private
	NSString *href;
	NSDate *modificationDate;
	long long contentLength;
	NSString *contentType;
	NSDate *creationDate;
	NSDictionary *attributes;
}

@property (copy) NSString *href;
@property (retain) NSDate *modificationDate;
@property (assign) long long contentLength;
@property (retain) NSString *contentType;
@property (retain) NSDate *creationDate;
@property (copy) NSDictionary *fileAttributes;  // like NSFileManager returns

@end
