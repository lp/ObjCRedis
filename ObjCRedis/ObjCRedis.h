//
//  ObjCRedis.h
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

- (NSArray*)keys:(NSString*)pattern;
- (NSString*)randomKey;

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

- (NSArray*)mget:(NSArray*)keys;

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
 @abstract Return a substring of a larger string.
 @result An NSString representing the substring or an empty string if the substring is not existent.
*/
- (NSString*)substr:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;

// List Methods

/*!
  @method rpush:to:
  @abstract Append an element to the tail of the List value at key
  @result If Redis server version is 2.0 or later the number of elements inside the list after the push operation is returned on success.
*/
- (NSNumber*)rpush:(NSString*)value to:(NSString*)key;
/*!
  @method lpush:to:
  @abstract Append an element to the head of the List value at key
  @result If Redis server version is 2.0 or later the number of elements inside the list after the push operation is returned on success.
*/
- (NSNumber*)lpush:(NSString*)value to:(NSString*)key;
/*!
  @method llen:
  @abstract Return the length of the List value at key
  @result returns length of list
*/
- (NSNumber*)llen:(NSString*)key;
/*!
  @method lrange:from:to:
  @abstract Return a range of elements from the List at key
  @result NSArray containing ordered items from range
*/
- (NSArray*)lrange:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method ltrim:from:to:
  @abstract Trim the list at key to the specified range of elements.
  @result An NSNumber returning -1 if the members were not removed.
*/
- (NSNumber*)ltrim:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method lindex:of:
  @abstract Return the element at index position from the List at key
  @result An NSString of the member.
*/
- (NSString*)lindex:(NSNumber*)index of:(NSString*)key;
/*!
  @method lset:at:to:
  @abstract Set a new value as the element at index position of the List at key.
  @result An NSNumber returning -1 if the element was not set.
*/
- (NSNumber*)lset:(NSString*)key at:(NSNumber*)index to:(NSString*)value;
/*!
  @method lrem:of:count:
  @abstract Remove the first-N, last-N, or all the elements matching value from the List at key.
  @result An NSNumber returning the number of elements removed.
*/
- (NSNumber*)lrem:(NSString*)value of:(NSString*)key count:(NSNumber*)count;
/*!
  @method lpop:
  @abstract Return and remove (atomically) the first element of the List at key.
  @result An NSNumber returning -1 if the key doesn't exists.
*/
- (NSString*)lpop:(NSString*)key;
/*!
  @method rpop:
  @abstract Return and remove (atomically) the last element of the List at key
  @result An NSNumber returning -1 if the key doesn't exists.
*/
- (NSString*)rpop:(NSString*)key;

// Sets Methods

/*!
  @method sadd:to:
  @abstract Add the specified member to the Set value at key.
  @result An NSNumber returning -1 if the given member was already a member of the set.
*/
- (NSNumber*)sadd:(NSString*)value to:(NSString*)key;
/*!
  @method srem:of:
  @abstract Remove the specified member from the Set value at key.
  @result An NSNumber returning -1 if the given member is not a member of the set.
*/
- (NSNumber*)srem:(NSString*)value of:(NSString*)key;
/*!
  @method spop:
  @abstract Remove and return (pop) a random element from the Set value at key.
  @result Returns nil if the given key doesn't exists, else value is returned as NSString
*/
- (NSString*)spop:(NSString*)key;
/*!
  @method smove:from:to:
  @abstract Move the specified member from one Set to another atomically.
  @result An NSNumber returning -1 if the member doesn't exists in the source set.
*/
- (NSNumber*)smove:(NSString*)value from:(NSString*)from to:(NSString*)to;
/*!
  @method scard:
  @abstract Return the number of elements (the cardinality) of the Set at key.
  @result An NSNumber returning the cardinality (number of members) or 0 if the given key doesn't exists.
*/
- (NSNumber*)scard:(NSString*)value;
/*!
  @method sismember:of:
  @abstract Test if the specified value is a member of the Set at key.
  @result An NSNumber returning -1 if the key doesn't exists and 0 if it does.
*/
- (NSNumber*)sismember:(NSString*)member of:(NSString*)key;
/*!
  @method sinter:
  @abstract Return the intersection between the Sets stored at key1, key2, ..., keyN.
  @result An NSSet containing the intersecting members.
*/
- (NSSet*)sinter:(NSSet*)members;
/*!
  @method sinterstore:to:
  @abstract Compute the intersection between the Sets stored at key1, key2, ..., keyN, and store the resulting Set at key.
  @result An NSNumber returning the number of intersecting members stored in destination set.
*/
- (NSNumber*)sinterstore:(NSArray*)members to:(NSString*)key;
/*!
  @method sunion:
  @abstract Return the union between the Sets stored at key1, key2, ..., keyN.
  @result An NSSet containing the united sets members.
*/
- (NSSet*)sunion:(NSSet*)members;
/*!
  @method sunionstore:to:
  @abstract Compute the union between the Sets stored at key1, key2, ..., keyN, and store the resulting Set at key
  @result An NSNumber returning the number of united sets members stored in destination set.
*/
- (NSNumber*)sunionstore:(NSArray*)members to:(NSString*)key;
/*!
  @method sdiff:
  @abstract Return the difference between the Set stored at key1 and all the Sets key2, ..., keyN.
  @result An NSSet containing the differing members.
*/
- (NSSet*)sdiff:(NSArray*)members;
/*!
  @method sdiffstore:to:
  @abstract Compute the difference between the Set key1 and all the Sets key2, ..., keyN, and store the resulting Set at key
  @result An NSNumber returning the number of differing members stored in destination set.
*/
- (NSNumber*)sdiffstore:(NSArray*)members to:(NSString*)key;
/*!
  @method smembers:
  @abstract Return all the members of the Set value at key.
  @result An NSSet containing all the members of the set.
*/
- (NSSet*)smembers:(NSString*)key;

// Sorted Sets Methods

/*!
  @method zadd:to:at:
  @abstract Add the specified member to the Sorted Set value at key or update the score if it already exist.
  @result An NSNumber returning -1 if member was already a member of the sorted set and only score was updated, 0 is returned if the new element was added.
*/
- (NSNumber*)zadd:(NSString*)value to:(NSString*)key at:(NSNumber*)score;
/*!
  @method zrem:of:
  @abstract Remove the specified member from the Sorted Set value at key.
  @result An NSNumber returning -1 if the member was not a member of the sorted set.
*/
- (NSNumber*)zrem:(NSString*)value of:(NSString*)key;
/*!
  @method zincr:by:of
  @abstract If the member already exists increment its score by increment, otherwise add the member setting increment as score.
  @result An NSNumber returning the score of the member after the increment.
*/
- (NSNumber*)zincr:(NSString*)value by:(NSNumber*)incr of:(NSString*)key;
/*!
  @method zrank:of:
  @abstract Return the rank (or index) or member in the sorted set at key, with scores being ordered from low to high.
  @result An NSNumber returning the rank of the given member or -1 if the member was not a member of the sorted set.
*/
- (NSNumber*)zrank:(NSString*)value of:(NSString*)key;
/*!
  @method zrevrank:of:
  @abstract Return the rank (or index) or member in the sorted set at key, with scores being ordered from high to low.
  @result An NSNumber returning the reverse rank of the given member or -1 if the member was not a member of the sorted set.
*/
- (NSNumber*)zrevrank:(NSString*)value of:(NSString*)key;
/*!
  @method zrange:from:to:
  @abstract Return a range of elements from the sorted set at key.
  @result An NSArray of sorted members in range.
*/
- (NSArray*)zrange:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method zrevrange:from:to:
  @abstract Return a range of elements from the sorted set at key, exactly like ZRANGE, but the sorted set is ordered in traversed in reverse order, from the greatest to the smallest score.
  @result An NSArray of sorted members in range in reverse order.
*/
- (NSArray*)zrevrange:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method zcard:
  @abstract Return the cardinality (number of elements) of the sorted set at key.
  @result An NSNumber returning the cardinality or -1 if 'key' does not exist.
*/
- (NSNumber*)zcard:(NSString*)key;
/*!
  @method zscore:of:
  @abstract Return the score associated with the specified element of the sorted set at key.
  @result Returns nil if the 'key' does not exist or the 'member' is not in the sorted set, Otherwise returns an NSNumber with the members score.
*/
- (NSNumber*)zscore:(NSString*)value of:(NSString*)key;
/*!
  @method zremrangebyscore:from:to:
  @abstract Remove all the elements with score >= min and score <= max from the sorted set.
  @result An NSNumber returning the number of elements removed or -1 if key does not exist.
*/
- (NSNumber*)zremrangebyscore:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method zremrangebyrank:from:to:
  @abstract Remove all the elements with rank >= min and rank <= max from the sorted set.
  @result An NSNumber returning the number of elements removed or -1 if key does not exist.
*/
- (NSNumber*)zremrangebyrank:(NSString*)key from:(NSNumber*)from to:(NSNumber*)to;
/*!
  @method zinterstore:to:
  @abstract Perform an intersection over a number of sorted sets with default weights and aggregate.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)zinterstore:(NSArray*)keys to:(NSString*)key;
/*!
  @method zinterstore:to:weights:aggregate:
  @abstract Perform an intersection over a number of sorted sets with weights and aggregate.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)zinterstore:(NSArray*)keys to:(NSString*)key weights:(NSArray*)weights aggregate:(NSString*)aggr;
/*!
  @method zunionstore:to:
  @abstract Perform a union over a number of sorted sets with default weights and aggregate
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)zunionstore:(NSArray*)keys to:(NSString*)key;
/*!
  @method zunionstore:to:weights:aggregate:
  @abstract Perform a union over a number of sorted sets with weights and aggregate
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)zunionstore:(NSArray*)keys to:(NSString*)key weights:(NSArray*)weights aggregate:(NSString*)aggr;

// Hashes

// Sort

/*!
  @method sort:
  @abstract Sort a Set or a List.
  @result An NSArray containing the sorted members
*/
- (NSArray*)sort:(NSString*)key;

// Publish Subscribe

- (NSNumber*)subscribe:(NSString*)channel;
- (NSNumber*)unsubscribe:(NSString*)channel;

// Persistence
/*!
  @method save
  @abstract Synchronously save the DB on disk.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)save;
/*!
  @method bgsave
  @abstract Asynchronously save the DB on disk.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)bgsave;
/*!
  @method lastsave
  @abstract Return the UNIX time stamp of the last successfully saving of the dataset on disk.
  @result An NSNumber representing the time.
*/
- (NSNumber*)lastsave; // could return NSDate???
/*!
  @method bgrewriteaof
  @abstract Rewrite the append only file in background when it gets too big.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)bgrewriteaof;
/*!
  @method shutdown
  @abstract Synchronously save the DB on disk, then shutdown the server.
  @result An NSNumber following Credis error conventions.
*/
- (NSNumber*)shutdown;

// Helper Method
- (REDIS_AGGREGATE)aggregate:(NSString*)aggregate;

@end
