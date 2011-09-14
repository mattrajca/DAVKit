//
//  DAVBaseRequest.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class DAVCredentials;

@interface DAVBaseRequest : NSOperation
{
  @private
    NSURL           *_rootURL;
    DAVCredentials  *_credentials;
    BOOL            _allowUntrustedCertificate;
}

@property (retain) NSURL *rootURL;
@property (retain) DAVCredentials *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@end
