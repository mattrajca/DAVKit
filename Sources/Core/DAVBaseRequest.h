//
//  DAVBaseRequest.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class DAVCredentials;

@interface DAVBaseRequest : NSOperation {
	
}

@property (retain) NSURL *rootURL;
@property (retain) DAVCredentials *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@end
