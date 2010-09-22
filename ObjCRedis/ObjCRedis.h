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
- (NSNumber*)set:(NSString*)key to:(NSString*)value;
- (NSString*)get:(NSString*)key;

@end
