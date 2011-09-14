//
//  DAVListingParser.h
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

@class DAVResponseItem;


#if defined MAC_OS_X_VERSION_MAX_ALLOWED && (!defined MAC_OS_X_VERSION_10_6 || MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_6)
@protocol NSXMLParserDelegate <NSObject>
@end
#endif


@interface DAVListingParser : NSObject < NSXMLParserDelegate > {
  @private
	NSXMLParser *_parser;
	NSMutableString *_currentString;
	NSMutableArray *_items;
	DAVResponseItem *_currentItem;
	BOOL _inResponseType;
}

- (id)initWithData:(NSData *)data;

- (NSArray *)parse:(NSError **)error;

@end
