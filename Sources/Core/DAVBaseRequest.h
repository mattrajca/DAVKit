//
//  DAVBaseRequest.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

@class DAVSession;

@interface DAVBaseRequest : NSOperation
{
  @private
    DAVSession  *_session;
}

- (id)initWithSession:(DAVSession *)session; /* designated intializer */
@property(retain, readonly) DAVSession *session;

@end
