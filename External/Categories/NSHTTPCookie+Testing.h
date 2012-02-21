@interface NSHTTPCookie (IGPropertyTesting)

- (BOOL)isExpired;
- (BOOL)isForHost:(NSString *)host;
- (BOOL)isForPath:(NSString *)path;
- (BOOL)isForRequest:(NSURLRequest *)request;

- (BOOL)isEqual:(id)object;

@end
