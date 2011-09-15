//
//  DAVBaseRequest.m
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "DAVBaseRequest.h"

@implementation DAVBaseRequest

@synthesize session = _session;

- (void)dealloc {
    [_session release];
	
	[super dealloc];
}

@end
