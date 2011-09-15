//
//  DAVSession.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class DAVBaseRequest;
@protocol DAVSessionDelegate;

/* All paths are relative to the root of the server */


@interface DAVSession : NSObject {
  @private
	NSURL *_rootURL;
	NSURLCredential *_credentials;
	NSOperationQueue *_queue;
    BOOL _allowUntrustedCertificate;
    
    id <DAVSessionDelegate> _delegate;
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
- (id)initWithRootURL:(NSURL *)url delegate:(id <DAVSessionDelegate>)delegate;

- (void)enqueueRequest:(DAVBaseRequest *)aRequest;

- (void)resetCredentialsCache;

@end


@protocol DAVSessionDelegate <NSObject>
@optional
- (void)webDAVSession:(DAVSession *)session didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)webDAVSession:(DAVSession *)session didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end
