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
@property (strong) NSDate *modificationDate;
@property (assign) long long contentLength;
@property (strong) NSString *contentType;
@property (strong) NSDate *creationDate;
@property (assign) DAVResourceType resourceType;

- (NSComparisonResult)compare:(DAVResponseItem *)item;

@end
