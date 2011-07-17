//
//  DAVResponseItem.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

typedef enum {
	DAVResourceTypeUnspecified,
	DAVResourceTypeCollection
} DAVResourceType;

@interface DAVResponseItem : NSObject {
  @private
	NSString *href;
	NSDate *modificationDate;
	long long contentLength;
	NSString *contentType;
	NSDate *creationDate;
	DAVResourceType resourceType;
}

@property (copy) NSString *href;
@property (retain) NSDate *modificationDate;
@property (assign) long long contentLength;
@property (retain) NSString *contentType;
@property (retain) NSDate *creationDate;
@property (assign) DAVResourceType resourceType;

@end
