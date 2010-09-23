//
//  ObjCRedis.h
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-20.
//  Copyright 2010 Modul. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "credis.h"

@interface ObjCRedis : NSObject {
	REDIS rh;
}

+ (id)redis;

+ (id)redis:(NSString*)ipaddress on:(NSNumber*)portnumber;

- (NSNumber*)connect:(NSString*)ipaddress on:(NSNumber*)portnumber;

// General Methods
- (NSNumber*)exists:(NSString*)key;
- (NSNumber*)del:(NSString*)key;
- (NSNumber*)type:(NSString*)key;
// TODO keys
// TODO randomkey
- (NSNumber*)rename:(NSString*)key to:(NSString*)newKey;
- (NSNumber*)renamenx:(NSString*)key to:(NSString*)newKey;
- (NSNumber*)dbsize;
- (NSNumber*)expire:(NSString*)key in:(NSNumber*)time;
- (NSNumber*)ttl:(NSString*)key;
- (NSNumber*)select:(NSNumber*)index;
- (NSNumber*)move:(NSString*)key to:(NSNumber*)index;
- (NSNumber*)flushdb;
- (NSNumber*)flushall;

// String Methods
- (NSNumber*)set:(NSString*)key to:(NSString*)value;
- (NSString*)get:(NSString*)key;
- (NSString*)getset:(NSString*)key to:(NSString*)value;
// TODO mget
- (NSNumber*)setnx:(NSString*)key to:(NSString*)value;
- (NSNumber*)incr:(NSString*)key;
- (NSNumber*)incr:(NSString*)key by:(NSNumber*)incrValue;
- (NSNumber*)decr:(NSString*)key;
- (NSNumber*)decr:(NSString*)key by:(NSNumber*)decrValue;
- (NSNumber*)append:(NSString*)value to:(NSString*)key;

@end
