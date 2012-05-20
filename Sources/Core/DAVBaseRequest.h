//
//  DAVBaseRequest.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class DAVCredentials;

@interface DAVBaseRequest : NSOperation {
	
}

@property (strong) NSURL *rootURL;
@property (strong) DAVCredentials *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@end
