//
//  DAVBaseRequest.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//


@interface DAVBaseRequest : NSOperation
{
  @private
    NSURL           *_rootURL;
    NSURLCredential *_credentials;
    BOOL            _allowUntrustedCertificate;
}

@property (retain) NSURL *rootURL;
@property (retain) NSURLCredential *credentials;
@property (assign) BOOL allowUntrustedCertificate;

@end
