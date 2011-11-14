//
//  DAVRequest.m
//  DAVKit
//
//  Copyright Matt Rajca 2010. All rights reserved.
//

#import "DAVRequest.h"

#import "DAVSession.h"

@interface DAVRequest ()

- (void)_didFail:(NSError *)error;
- (void)_didFinish;

@end


@implementation DAVRequest

NSString *const DAVClientErrorDomain = @"com.MattRajca.DAVKit.error";

#define DEFAULT_TIMEOUT 60

- (id)initWithPath:(NSString *)aPath session:(DAVSession *)session delegate:(id <DAVRequestDelegate>)delegate;
{
	NSParameterAssert(aPath != nil);
	
	self = [self initWithSession:session];
	if (self) {
		_path = [aPath copy];
        _delegate = [delegate retain];  // retained till finish running/cancelled
	}
	return self;
}

@synthesize path = _path;
@synthesize delegate = _delegate;

- (NSURL *)concatenatedURLWithPath:(NSString *)aPath {
	NSParameterAssert(aPath != nil);
	
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_6
	return [self.session.rootURL URLByAppendingPathComponent:aPath];
#else
    CFURLRef result = CFURLCreateCopyAppendingPathComponent(NULL,
                                                             (CFURLRef)[self.session.rootURL absoluteURL],
                                                             (CFStringRef)aPath,
                                                             NO);
    return [NSMakeCollectable(result) autorelease];
#endif
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isExecuting {
	return _executing;
}

- (BOOL)isFinished {
	return _done;
}

- (void)cancel;
{
    [super cancel];
    [_connection cancel];
    [_delegate release]; _delegate = nil;
}

- (void)start {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(start) 
							   withObject:nil waitUntilDone:NO];
		
		return;
	}
	
	[self willChangeValueForKey:@"isExecuting"];
	
	_executing = YES;
	_connection = [[NSURLConnection connectionWithRequest:[self request]
												 delegate:self] retain];
	
	if ([_delegate respondsToSelector:@selector(requestDidBegin:)])
		[_delegate requestDidBegin:self];
	
	[self didChangeValueForKey:@"isExecuting"];
}

- (NSURLRequest *)request {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:@"Subclasses of DAVRequest must override 'request'"
								 userInfo:nil];
	
	return nil;
}

- (id)resultForData:(NSData *)data {
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (!_data) {
		_data = [[NSMutableData alloc] init];
	}
	
	[_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self _didFail:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
	NSInteger code = [resp statusCode];
    
    // Report to transcript
    [[self session] appendFormatToReceivedTranscript:@"%i %@", code, [[resp class] localizedStringForStatusCode:code]];
	
	if (code >= 400) {
		[_connection cancel];
		
        // TODO: Formalize inclusion of response
		NSError *error = [NSError errorWithDomain:DAVClientErrorDomain
											 code:code
										 userInfo:[NSDictionary dictionaryWithObject:response forKey:@"response"]];
		
		[self _didFail:error];
	}
}

#if defined MAC_OS_X_VERSION_MAX_ALLOWED && MAC_OS_X_VERSION_10_6 >= MAC_OS_X_VERSION_MAX_ALLOWED
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	BOOL result = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault] ||
	[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ||
	[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest] ||
	[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
	
	return result;
}
#endif

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    id <DAVSessionDelegate> delegate = [self.session valueForKey:@"delegate"];
    if ([delegate respondsToSelector:@selector(webDAVSession:didReceiveAuthenticationChallenge:)])
    {
        [delegate webDAVSession:self.session didReceiveAuthenticationChallenge:challenge];
        return;
    }
    
#if defined MAC_OS_X_VERSION_MAX_ALLOWED && MAC_OS_X_VERSION_10_6 >= MAC_OS_X_VERSION_MAX_ALLOWED
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
		if (self.session.allowUntrustedCertificate)
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
				 forAuthenticationChallenge:challenge];
		
		[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	}
    else
#endif
    {
		if ([challenge previousFailureCount] == 0) {
			[[challenge sender] useCredential:[challenge proposedCredential] forAuthenticationChallenge:challenge];
		} else {
			// Wrong login/password
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    id <DAVSessionDelegate> delegate = [self.session valueForKey:@"delegate"];
    if ([delegate respondsToSelector:@selector(webDAVSession:didCancelAuthenticationChallenge:)])
    {
        [delegate webDAVSession:self.session didCancelAuthenticationChallenge:challenge];
    }
}

- (void)_didFail:(NSError *)error {
	if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[_delegate request:self didFailWithError:[[error retain] autorelease]];
	}
	
	[self _didFinish];
}

- (void)_didFinish {
	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	
	_done = YES;
	_executing = NO;
	
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
    
    [_delegate release]; _delegate = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if ([_delegate respondsToSelector:@selector(request:didSucceedWithResult:)]) {
		id result = [self resultForData:_data];
		
		[_delegate request:self didSucceedWithResult:[[result retain] autorelease]];
	}
	
	[self _didFinish];
}

- (void)dealloc {
	[_path release];
	[_connection release];
	[_data release];
	
	[super dealloc];
}

@end


@implementation DAVRequest (Private)

- (NSMutableURLRequest *)newRequestWithPath:(NSString *)path method:(NSString *)method {
	NSURL *url = [self concatenatedURLWithPath:path];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:method];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:DEFAULT_TIMEOUT];
	
	return request;
}

@end
