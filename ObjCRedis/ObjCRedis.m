//
//  ObjCRedis.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-20.
//  Copyright (c) 2010 Louis-Philippe Perron.
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// 


#import "ObjCRedis.h"
#import "NSArray+WithCVector.h"
#import "NSSet+WithCVector.h"

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
- (NSString*)lindex:(NSNumber *)index of:(NSString *)key {
	char * value = NULL;
	int exist = credis_lindex(rh, [key UTF8String], [index intValue], &value);
	if (exist != -1) { return [NSString stringWithUTF8String:value]; }
	else { return nil; }
}
- (NSNumber*)lset:(NSString *)key at:(NSNumber *)index to:(NSString *)value {
	return [NSNumber numberWithInt:credis_lset(rh, [key UTF8String], [index intValue], [value UTF8String])];
}
- (NSNumber*)lrem:(NSString *)value of:(NSString *)key count:(NSNumber *)count {
	return [NSNumber numberWithInt:credis_lrem(rh, [key UTF8String], [count intValue], [value UTF8String])];
}

- (NSString*)lpop:(NSString *)key {
	char * value;
	int success = credis_lpop(rh, [key UTF8String], &value);
	if (success != -1) { return [NSString stringWithUTF8String:value]; }
	else { return nil; }
}
- (NSString*)rpop:(NSString *)key {
	char * value;
	int success = credis_rpop(rh, [key UTF8String], &value);
	if (success != -1) { return [NSString stringWithUTF8String:value]; }
	else { return nil; }
}

// Sets

- (NSNumber*)sadd:(NSString *)value to:(NSString *)key {
	return [NSNumber numberWithInt:credis_sadd(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)srem:(NSString*)value of:(NSString*)key {
	return [NSNumber numberWithInt:credis_srem(rh, [key UTF8String], [value UTF8String])];
}
- (NSString*)spop:(NSString *)key {
	char * value;
	int success = credis_spop(rh, [key UTF8String], &value);
	if (success != -1) { return [NSString stringWithUTF8String:value]; } 
	else { return nil; }
}
- (NSNumber*)smove:(NSString *)value from:(NSString *)from to:(NSString *)to {
	return [NSNumber numberWithInt:
			credis_smove(rh, [from UTF8String], [to UTF8String], [value UTF8String])];
}
- (NSNumber*)scard:(NSString*)value {
	return [NSNumber numberWithInt:credis_scard(rh, [value UTF8String])];
}
- (NSNumber*)sismember:(NSString *)member of:(NSString*)key {
	return [NSNumber numberWithInt:credis_sismember(rh, [key UTF8String], [member UTF8String])];
}
- (NSSet*)sinter:(NSSet*)members {
	char ** vec;
	int numret = credis_sinter(rh, (int)[members count], [members cVector], &vec);
	return [NSSet setWithCVector:vec ofSize:numret];
}
- (NSNumber*)sinterstore:(NSArray *)members to:(NSString *)key {
	return [NSNumber numberWithInt:credis_sinterstore(rh, [key UTF8String], (int)[members count], [members cVector])];
}
- (NSSet*)sunion:(NSSet*)members {
	char ** vec;
	int numret = credis_sunion(rh, (int)[members count], [members cVector], &vec);
	return [NSSet setWithCVector:vec ofSize:numret];
}
- (NSNumber*)sunionstore:(NSArray *)members to:(NSString *)key {
	return [NSNumber numberWithInt:credis_sunionstore(rh, [key UTF8String], (int)[members count], [members cVector])];
}
- (NSSet*)sdiff:(NSArray*)members {
	char ** vec;
	int numret = credis_sdiff(rh, (int)[members count], [members cVector], &vec);
	return [NSSet setWithCVector:vec ofSize:numret];
}
- (NSNumber*)sdiffstore:(NSArray *)members to:(NSString *)key {
	return [NSNumber numberWithInt:credis_sdiffstore(rh, [key UTF8String], (int)[members count], [members cVector])];
}
- (NSSet*)smembers:(NSString *)key {
	char ** vec;
	int numret = credis_smembers(rh, [key UTF8String], &vec);
	return [NSSet setWithCVector:vec ofSize:numret];
}

// Sorted Sets

- (NSNumber*)zadd:(NSString *)value to:(NSString *)key at:(NSNumber *)score {
	return [NSNumber numberWithInt:credis_zadd(rh, [key UTF8String], [score doubleValue], [value UTF8String])];
}
- (NSNumber*)zrem:(NSString *)value of:(NSString *)key {
	return [NSNumber numberWithInt:credis_zrem(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)zincr:(NSString *)value by:(NSNumber *)incr of:(NSString *)key {
	double rscore;
	if (credis_zincrby(rh, [key UTF8String], [incr doubleValue], [value UTF8String], &rscore) == 0) {
		return [NSNumber numberWithDouble:rscore]; }
	else {
		return nil; }
}
- (NSNumber*)zrank:(NSString *)value of:(NSString *)key {
	return [NSNumber numberWithInt:credis_zrank(rh, [key UTF8String], [value UTF8String])];
}
- (NSNumber*)zrevrank:(NSString *)value of:(NSString *)key {
	return [NSNumber numberWithInt:credis_zrevrank(rh, [key UTF8String], [value UTF8String])];
}
- (NSArray*)zrange:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	char ** vec;
	int numret = credis_zrange(rh, [key UTF8String], [from intValue], [to intValue], &vec);
	return [NSArray arrayWithCVector:vec ofSize:numret];
}
- (NSArray*)zrevrange:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	char ** vec;
	int numret = credis_zrevrange(rh, [key UTF8String], [from intValue], [to intValue], &vec);
	return [NSArray arrayWithCVector:vec ofSize:numret];
}
- (NSNumber*)zcard:(NSString *)key {
	return [NSNumber numberWithInt:credis_zcard(rh, [key UTF8String])];
}
- (NSNumber*)zscore:(NSString *)value of:(NSString *)key {
	double score;
	if (credis_zscore(rh, [key UTF8String], [value UTF8String], &score) == 0) {
		return [NSNumber numberWithDouble:score]; }
	else { return nil; }
}
- (NSNumber*)zremrangebyscore:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	return [NSNumber numberWithInt:credis_zremrangebyscore(rh, [key UTF8String], [from doubleValue], [to doubleValue])];
}
- (NSNumber*)zremrangebyrank:(NSString *)key from:(NSNumber *)from to:(NSNumber *)to {
	return [NSNumber numberWithInt:credis_zremrangebyrank(rh, [key UTF8String], [from intValue], [to intValue])];
}
- (NSNumber*)zinterstore:(NSArray *)keys to:(NSString *)key {
	return [NSNumber numberWithInt:
			credis_zinterstore(rh,
							   [key UTF8String],
							   (int)[keys count],
							   [keys cVector],
							   [[NSArray arrayWithNumber:[NSNumber numberWithInt:1] ofSize:[keys count]] intArray],
							   SUM)];
}

- (NSNumber*)zinterstore:(NSArray *)keys to:(NSString *)key weights:(NSArray*)weights aggregate:(NSString*)aggr {
	return [NSNumber numberWithInt:
			credis_zinterstore(rh,
							   [key UTF8String],
							   (int)[keys count],
							   [keys cVector],
							   [weights intArray],
							   [self aggregate:aggr])];
}
- (NSNumber*)zunionstore:(NSArray *)keys to:(NSString *)key {
	return [NSNumber numberWithInt:
			credis_zunionstore(rh,
							   [key UTF8String],
							   (int)[keys count],
							   [keys cVector],
							   [[NSArray arrayWithNumber:[NSNumber numberWithInt:1] ofSize:[keys count]] intArray],
							   SUM)];
}
- (NSNumber*)zunionstore:(NSArray*)keys to:(NSString*)key weights:(NSArray*)weights aggregate:(NSString*)aggr {
	return [NSNumber numberWithInt:
			credis_zunionstore(rh,
							   [key UTF8String],
							   (int)[keys count],
							   [keys cVector],
							   [weights intArray],
							   [self aggregate:aggr])];
}

// Sort
- (NSArray*)sort:(NSString *)key {
	char ** vec;
	int numret = credis_sort(rh, [key UTF8String], &vec);
	return [NSArray arrayWithCVector:vec ofSize:numret];
}

// Persistence
- (NSNumber*)save { return [NSNumber numberWithInt:credis_save(rh)]; }
- (NSNumber*)bgsave { return [NSNumber numberWithInt:credis_bgsave(rh)]; }
- (NSNumber*)lastsave { return [NSNumber numberWithInt:credis_lastsave(rh)]; }
- (NSNumber*)bgrewriteaof { return [NSNumber numberWithInt:credis_bgrewriteaof(rh)]; }

// Helper Method
- (REDIS_AGGREGATE)aggregate:(NSString *)aggregate {
	if ([aggregate isEqualToString:@"NONE"]) {
		return NONE;
	} else if ([aggregate isEqualToString:@"MIN"]) {
		return MIN;
	} else if ([aggregate isEqualToString:@"MAX"]) {
		return MAX;
	} else if ([aggregate isEqualToString:@"SUM"]) {
		return SUM;
	} else {
		return SUM;
	}
}



- (void)dealloc
{	
	credis_close(rh);
	[super dealloc];
}



@end
