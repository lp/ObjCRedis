//
//  NSArray+WithCVector.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-24.
//  Copyright 2010 Modul. All rights reserved.
//

#import "NSArray+WithCVector.h"

@implementation NSArray (WithCVector)

+ (NSArray*)arrayWithCVector:(char**)vec ofSize:(int)size
{
	NSMutableArray * buildArray = [NSMutableArray array];
	for (int i; i < size; i++) {
		[buildArray addObject:[NSString stringWithUTF8String:vec[i]]];
	}
	return [NSArray arrayWithArray:buildArray];
}

@end
