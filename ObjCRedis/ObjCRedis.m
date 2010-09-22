//
//  ObjCRedis.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-20.
//  Copyright 2010 Modul. All rights reserved.
//

#import "ObjCRedis.h"

@implementation ObjCRedis

+ (id)redis
{	
	return [ObjCRedis redis:@"localhost" on:[NSNumber numberWithInt:6379]];
}

+ (id)redis:(NSString*)ipaddress on:(NSNumber*)portnumber
{
	ObjCRedis * r = [[ObjCRedis alloc] init];
	NSNumber * retval = [r connect:ipaddress on:portnumber];
	[r autorelease];
	if ([retval isEqualToNumber:[NSNumber numberWithBool:YES]]) {
		return r;
	} else {
		return nil;
	}
}

- (NSNumber*)connect:(NSString *)ipaddress on:(NSNumber *)portnumber
{
	rh = credis_connect([ipaddress UTF8String],[portnumber intValue], 2000);
	
	if (rh) { return [NSNumber numberWithBool:YES];
	}
	else { return [NSNumber numberWithBool:NO];
	}
}

- (NSNumber*)set:(NSString *)key to:(NSString *)value
{
	const char * rKey = [key UTF8String];
	const char * rValue = [value UTF8String];
	
	return [NSNumber numberWithInt:credis_set(rh, rKey, rValue)];
}

- (NSString*)get:(NSString *)key
{
	const char * rKey = [key UTF8String];
	char * rValue;
	
	credis_get(rh, rKey, &rValue);
	return [NSString stringWithUTF8String:rValue];
}

- (void)dealloc
{	
	credis_close(rh);
	[super dealloc];
}



@end
