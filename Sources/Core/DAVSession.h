//
//  DAVSession.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class DAVBaseRequest;

/* All paths are relative to the root of the server */

@interface DAVSession : NSObject {
  @private
	NSURL *_rootURL;
	NSURLCredential *_credentials;
	NSOperationQueue *_queue;
    BOOL _allowUntrustedCertificate;
}

@property (readonly) NSURL *rootURL;
@property (readonly) NSURLCredential *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@property (readonly) NSUInteger requestCount; /* KVO compliant */
@property (assign) NSInteger maxConcurrentRequests; /* default is 2 */

/*
 The root URL should include a scheme and host, followed by any root paths
 **NOTE: omit the trailing slash (/)**
 Example: http://idisk.me.com/steve
*/
- (id)initWithRootURL:(NSURL *)url credentials:(NSURLCredential *)credentials;

- (void)enqueueRequest:(DAVBaseRequest *)aRequest;

- (void)resetCredentialsCache;

@end
