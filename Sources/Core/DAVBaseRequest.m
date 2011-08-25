//
//  DAVBaseRequest.m
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "DAVBaseRequest.h"

@implementation DAVBaseRequest

@synthesize rootURL = _rootURL, credentials = _credentials;
@synthesize allowUntrustedCertificate = _allowUntrustedCertificate;

- (void)dealloc {
    [_rootURL release];
	[_credentials release];
	
	[super dealloc];
}

@end
