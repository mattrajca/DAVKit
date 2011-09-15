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

@property(nonatomic, retain) DAVSession *session;   /* only the session should set this */

@end
