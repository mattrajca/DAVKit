//
//  DAVSession.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class DAVCredentials;
@class DAVRequest;

/* All paths are relative to the root of the server */

@interface DAVSession : NSObject {
  @private
	NSURL *_rootURL;
	DAVCredentials *_credentials;
	NSOperationQueue *_queue;
}

@property (readonly) NSURL *rootURL;
@property (readonly) DAVCredentials *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@property (assign) NSInteger maxConcurrentRequests; /* default is 2 */

/*
 The root URL should include a scheme and host, followed by any root paths
 **NOTE: omit the trailing slash (/)**
 Example: http://idisk.me.com/steve
*/
- (id)initWithRootURL:(NSURL *)url credentials:(DAVCredentials *)credentials;

- (void)enqueueRequest:(NSOperation *)aRequest;

- (void)resetCredentialsCache;

@end
