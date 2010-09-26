//
//  ObjCRedis.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-20.
//  Copyright 2010 Modul. All rights reserved.
//

#import "ObjCRedis.h"
#import "NSArray+WithCVector.h"

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

- (NSNumber*)connect:(NSString *)ipaddress on:(NSNumber *)portnumber {
	rh = credis_connect([ipaddress UTF8String],[portnumber intValue], 2000);
	if (rh) { return [NSNumber numberWithBool:YES]; }
	else { return [NSNumber numberWithBool:NO]; }
}

// General Methods
- (NSNumber*)exists:(NSString *)key { return [NSNumber numberWithInt:credis_exists(rh, [key UTF8String])]; }
- (NSNumber*)del:(NSString*)key { return [NSNumber numberWithInt:credis_del(rh, [key UTF8String])]; }
- (NSNumber*)type:(NSString *)key { return [NSNumber numberWithInt:credis_type(rh, [key UTF8String])]; }
- (NSArray*)keys:(NSString *)pattern {
	char **keys;
	int nKeys = credis_keys(rh, [pattern UTF8String], &keys);
	return [NSArray arrayWithCVector:keys ofSize:nKeys];
}

// Not working???
- (NSString*)randomKey {
	char * rkey = NULL;
	credis_randomkey(rh, &rkey);
	if (rkey == NULL) { return nil; }
	return [NSString stringWithUTF8String:rkey];
}

- (NSNumber*)rename:(NSString *)key to:(NSString *)newKey {
	return [NSNumber numberWithInt:credis_rename(rh, [key UTF8String], [newKey UTF8String])];
}
- (NSNumber*)renamenx:(NSString *)key to:(NSString *)newKey {
	return [NSNumber numberWithInt:credis_renamenx(rh, [key UTF8String], [newKey UTF8String])];
}
- (NSNumber*)dbsize { return [NSNumber numberWithInt:credis_dbsize(rh)]; }
- (NSNumber*)expire:(NSString *)key in:(NSNumber *)time {
	return [NSNumber numberWithInt:credis_expire(rh, [key UTF8String], [time intValue])];
}
- (NSNumber*)ttl:(NSString*)key {
	return [NSNumber numberWithInt:credis_ttl(rh, [key UTF8String])];
}
- (NSNumber*)select:(NSNumber*)index {
	return [NSNumber numberWithInt:credis_select(rh, [index intValue])];
}
- (NSNumber*)move:(NSString *)key to:(NSNumber *)index {
	return [NSNumber numberWithInt:credis_move(rh, [key UTF8String], [index intValue])];
}
- (NSNumber*)flushdb { return [NSNumber numberWithInt:credis_flushdb(rh)]; }
- (NSNumber*)flushall { return [NSNumber numberWithInt:credis_flushall(rh)]; }

// String Methods
- (NSNumber*)set:(NSString *)key to:(NSString *)value {
	return [NSNumber numberWithInt:credis_set(rh, [key UTF8String], [value UTF8String])]; }
- (NSString*)get:(NSString *)key {
	char * rValue;	
	credis_get(rh, [key UTF8String], &rValue);
	return [NSString stringWithUTF8String:rValue];
}
- (NSString*)getset:(NSString *)key to:(NSString *)value {
	char * rValue;
	credis_getset(rh, [key UTF8String], [value UTF8String], &rValue);
	return [NSString stringWithUTF8String:rValue];
}
- (NSArray*)mget:(NSArray *)keys {
	char ** rVec;
	int vLen = credis_mget(rh, (int)[keys count], [keys cVector], &rVec);
	return [NSArray arrayWithCVector:rVec ofSize:vLen];
}


- (NSNumber*)setnx:(NSString *)key to:(NSString *)value {
	return [NSNumber numberWithInt:credis_setnx(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)incr:(NSString *)key {
	int rValue;
	credis_incr(rh, [key UTF8String], &rValue);
	return [NSNumber numberWithInt:rValue];
}
- (NSNumber*)incr:(NSString*)key by:(NSNumber*)incrValue {
	int rValue;
	credis_incrby(rh, [key UTF8String], [incrValue intValue], &rValue);
	return [NSNumber numberWithInt:rValue];
}
- (NSNumber*)decr:(NSString *)key {
	int rValue;
	credis_decr(rh, [key UTF8String], &rValue);
	return [NSNumber numberWithInt:rValue];
}
- (NSNumber*)decr:(NSString*)key by:(NSNumber*)decrValue {
	int rValue;
	credis_decrby(rh, [key UTF8String], [decrValue intValue], &rValue);
	return [NSNumber numberWithInt:rValue];
}
- (NSNumber*)append:(NSString *)value to:(NSString*)key {
	return [NSNumber numberWithInt:credis_append(rh, [key UTF8String], [value UTF8String])];
}
- (NSString*)substr:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	char * rValue;
	credis_substr(rh, [key UTF8String], [from intValue], [to intValue], &rValue);
	if (rValue != NULL) { return [NSString stringWithUTF8String:rValue]; } 
	else { return @""; }
}

// List Methods

- (NSNumber*)rpush:(NSString *)value to:(NSString *)key {
	return [NSNumber numberWithInt:credis_rpush(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)lpush:(NSString *)value to:(NSString *)key {
	return [NSNumber numberWithInt:credis_lpush(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)llen:(NSString *)key {
	return [NSNumber numberWithInt:credis_llen(rh, [key UTF8String])];
}

- (NSArray*)lrange:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	char ** vec;
	int numItems = credis_lrange(rh, [key UTF8String], [from intValue], [to intValue], &vec);
	return [NSArray arrayWithCVector:vec ofSize:numItems];
}

- (NSNumber*)ltrim:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	return [NSNumber numberWithInt:credis_ltrim(rh, [key UTF8String], [from intValue], [to intValue])];
}

- (NSNumber*)lset:(NSString *)key at:(NSNumber *)index to:(NSString *)value {
	return [NSNumber numberWithInt:credis_lset(rh, [key UTF8String], [index intValue], [value UTF8String])];
}
- (NSString*)lindex:(NSNumber *)index of:(NSString *)key {
	char * value = NULL;
	int exist = credis_lindex(rh, [key UTF8String], [index intValue], &value);
	if (exist != -1) {
		return [NSString stringWithUTF8String:value];
	} else {
		return nil;
	}
}


- (void)dealloc
{	
	credis_close(rh);
	[super dealloc];
}



@end
