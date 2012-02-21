
@implementation NSHTTPCookie (IGPropertyTesting)

- (BOOL)isExpired
{
	return [[self expiresDate] timeIntervalSinceNow] < 0;
}

- (BOOL)isForHost:(NSString *)host
{
	return ([[self domain] isEqualToString:host]
			|| ([[self domain] hasPrefix:@"."]
				&& [[NSString stringWithFormat:@".%@",host] hasSuffix:[self domain]])
			);
}

- (BOOL)isForPath:(NSString *)path;
{
	return (path
			&& [path hasPrefix:[self path]]
			);
}

- (BOOL)isForRequest:(NSURLRequest *)request
{
	return (![self isExpired]
			&& [self isForHost:[[request URL] host]]
			&& [self isForPath:[[request URL] path]]
			);
}

- (BOOL)isEqual:(id)object
{
	return ([object isKindOfClass:[self class]]
			&& [[self name] isEqualToString:[object name]]
			&& [[self domain] isEqualToString:[object domain]]
			&& [[self path] isEqualToString:[object path]]
			);
}

@end
