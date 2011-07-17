//
//  DAVResponseItem.m
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "DAVResponseItem.h"

@implementation DAVResponseItem

@synthesize href, modificationDate, contentLength, contentType;
@synthesize creationDate, resourceType;

- (id)init {
	self = [super init];
	if (self) {
		resourceType = DAVResourceTypeUnspecified;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"href = %@; modificationDate = %@; contentLength = %lld; "
									  @"contentType = %@; creationDate = %@; resourceType = %d;",
									  href, modificationDate, contentLength, contentType,
									  creationDate, resourceType];
}

- (void)dealloc {
	[href release];
	[modificationDate release];
	[contentType release];
	[creationDate release];
	
	[super dealloc];
}

@end
