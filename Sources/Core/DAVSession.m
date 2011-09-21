//
//  DAVSession.m
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "DAVSession.h"

#import "DAVRequest.h"
#import "DAVRequest+Private.h"
#import "DAVRequests.h"

@implementation DAVSession

@synthesize rootURL = _rootURL;
@synthesize allowUntrustedCertificate = _allowUntrustedCertificate;

- (id)initWithRootURL:(NSURL *)url delegate:(id <DAVSessionDelegate>)delegate;
{
	NSParameterAssert(url != nil);
	
	self = [super init];
	if (self) {
        _delegate = delegate;
		_rootURL = [url copy];
		_allowUntrustedCertificate = NO;
		
    }
	return self;
}

- (void)resetCredentialsCache {
	// reset the credentials cache...
	NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
	
	if ([credentialsDict count] > 0) {
		// the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
		NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
		id urlProtectionSpace;
		
		// iterate over all NSURLProtectionSpaces
		while ((urlProtectionSpace = [protectionSpaceEnumerator nextObject])) {
			NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
			id userName;
			
			// iterate over all usernames for this protection space, which are the keys for the actual NSURLCredentials
			while ((userName = [userNameEnumerator nextObject])) {
				NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
				
				[[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred
																forProtectionSpace:urlProtectionSpace];
			}
		}
	}
}

- (void)dealloc {
	[_rootURL release];
	
	[super dealloc];
}

@end
