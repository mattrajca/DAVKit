//
//  DAVBaseRequest.m
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "DAVBaseRequest.h"

@implementation DAVBaseRequest

- (id)initWithSession:(DAVSession *)session;
{
    NSParameterAssert(session);
    if (self = [super init])
    {
        _session = [session retain];
    }
    return self;
}

- (id)init; { return [self initWithSession:nil]; }

@synthesize session = _session;

- (void)dealloc {
    [_session release];
	
	[super dealloc];
}

@end
