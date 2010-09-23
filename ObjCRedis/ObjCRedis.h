//
//  ObjCRedis.h
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-20.
//  Copyright 2010 Modul. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "credis.h"

/*!
 @class ObjCRedis
 @abstract Object oriented wrapper around Credis Redis client
*/
@interface ObjCRedis : NSObject {
	REDIS rh;
}

/*!
 @method redis
 @abstract Instantiate an autoreleased redis object
 @discussion This method assumes default Redis server on localhost and port 6379
*/
+ (id)redis;

/*!
 @method redis:on:
 @abstract Instantiate an autoreleased redis object
 @discussion This method connect to a specified server and port
 @param ipaddress The server IPAddress as an NSString
 @param portnumber The server connection port as an NSNumber
*/
+ (id)redis:(NSString*)ipaddress on:(NSNumber*)portnumber;

// General Methods

/*!
 @method connect:on:
 @abstract Connect to the Redis server
 @discussion Connect the Redis client to a specified server and port
 @param ipaddress The server IPAddress as an NSString
 @param portnumber The server connection port as an NSNumber
 @result An NSNumber stating connection success
*/
- (NSNumber*)connect:(NSString*)ipaddress on:(NSNumber*)portnumber;

/*!
 @method exists:
 @abstract Test if a key exists
 @result An NSNumber returning -1 if the key doesn't exists and 0 if it does
*/
- (NSNumber*)exists:(NSString*)key;
/*!
 @method del:
 @abstract Delete a key
 @result Follows Credis error conventions
*/
- (NSNumber*)del:(NSString*)key;
/*!
 @method type:
 @abstract Return the type of the value stored at key
 @result An NSNumber representing a type with these correspondence: 1 = None, 2 = String, 3 = List, 4 = Set
*/
- (NSNumber*)type:(NSString*)key;

// TODO keys
// TODO randomkey

/*!
 @method rename:to:
 @abstract Rename the old key in the new one, destroying the newname key if it already exists
 @result Follows Credis error conventions
*/
- (NSNumber*)rename:(NSString*)key to:(NSString*)newKey;
/*!
 @method renamenx:to:
 @abstract Rename the oldname key to newname, if the newname key does not already exist
 @result Follows Credis error conventions
*/
- (NSNumber*)renamenx:(NSString*)key to:(NSString*)newKey;
/*!
 @method dbsize
 @abstract Return the number of keys in the current db
 @result An NSNumber representing the number of keys.
*/
- (NSNumber*)dbsize;
/*!
 @method expire:in:
 @abstract Set a time to live in seconds on a key
 @result An NSNumber returning -1 if the timeout was not set, either due to key already has an associated timeout or key does not exist
*/
- (NSNumber*)expire:(NSString*)key in:(NSNumber*)time;
/*!
 @method ttl:
 @abstract Get the time to live in seconds of a key
 @result An NSNumber representing the time to live in seconds or -1 if key does not exists or does not have expire set
*/
- (NSNumber*)ttl:(NSString*)key;
/*!
 @method select:
 @abstract Select the DB with the specified index
 @result Follows Credis error conventions
*/
- (NSNumber*)select:(NSNumber*)index;
/*!
 @method move:to:
 @abstract Move the key from the currently selected DB to the dbindex DB
 @result An NSNumber returning -1 if the key was not moved, already present at target or not found on current db
*/
- (NSNumber*)move:(NSString*)key to:(NSNumber*)index;
/*!
 @method flushdb
 @abstract Remove all the keys from the currently selected DB
 @result Follows Credis error conventions
*/
- (NSNumber*)flushdb;
/*!
 @method flushall
 @abstract Remove all the keys from all the databases
 @result Follows Credis error conventions
*/
- (NSNumber*)flushall;

// String Methods

/*!
 @method set:to:
 @abstract Set a key to a string value
 @result Follows Credis error conventions
*/
- (NSNumber*)set:(NSString*)key to:(NSString*)value;
/*!
 @method get:
 @abstract Return the string value of the key
 @result An NSString representing the string value of the key 
*/
- (NSString*)get:(NSString*)key;
/*!
 @method getset:to:
 @abstract Set a key to a string returning the old value of the key
 @result An NSString representing the old string value of the key
*/
- (NSString*)getset:(NSString*)key to:(NSString*)value;

// TODO mget

/*!
 @method setnx:to:
 @abstract Set a key to a string value if the key does not exist
 @result Follows Credis error conventions
*/
- (NSNumber*)setnx:(NSString*)key to:(NSString*)value;
/*!
 @method incr:
 @abstract Increment the integer value of key
 @result Return the value after the increment was performed, 0 if the value was NULL
*/
- (NSNumber*)incr:(NSString*)key;
/*!
 @method incr:by:
 @abstract Increment the integer value of key by integer
 @result Return the value after the increment was performed, 1 if the value was NULL
*/
- (NSNumber*)incr:(NSString*)key by:(NSNumber*)incrValue;
/*!
 @method decr:
 @abstract Decrement the integer value of key
 @result Return the value after the decrement was performed, 0 if the value was NULL
*/
- (NSNumber*)decr:(NSString*)key;
/*!
 @method decr:by:
 @abstract Decrement the integer value of key by integer
 @result Return the value after the decrement was performed, 1 if the value was NULL
*/
- (NSNumber*)decr:(NSString*)key by:(NSNumber*)decrValue;
/*!
 @method append:to:
 @abstract Append the specified string to the string stored at key
 @result Returns new length of string after append
*/
- (NSNumber*)append:(NSString*)value to:(NSString*)key;
/*!
 @method substr:from:to:
 @abstract Return a substring of a larger string
 @result An NSString representing the substring or an empty string if the substring is not existent
*/
- (NSString*)substr:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;

@end
