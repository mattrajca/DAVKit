//
//  DAVRequestGroup.h
//  DAVKit
//
//  Copyright Matt Rajca 2011. All rights reserved.
//

#import "DAVRequest.h"

@interface DAVRequestGroup : NSOperation < DAVRequestDelegate > {
  @private
	NSOperationQueue *_subQueue;
	NSMutableArray *_requests;
	BOOL _done, _executing;
}

/* The requests are executed serially; if one fails the remaining ones 
   are cancelled */

- (id)initWithRequests:(NSArray *)requests;

@end
