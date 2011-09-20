//
//  DAVResponseItem.m
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "DAVResponseItem.h"

@implementation DAVResponseItem

@synthesize href, modificationDate, contentLength, contentType;
@synthesize creationDate;
@synthesize fileAttributes = attributes;

- (NSString *)description {
	return [NSString stringWithFormat:@"href = %@; modificationDate = %@; contentLength = %lld; "
									  @"contentType = %@; creationDate = %@; attributes = %@;",
									  href, modificationDate, contentLength, contentType,
									  creationDate, attributes];
}

- (void)dealloc {
	[href release];
	[modificationDate release];
	[contentType release];
	[creationDate release];
	
	[super dealloc];
}

@end
