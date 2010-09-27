//
//  NSArray+WithCVector.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-24.
//  Copyright 2010 Louis-Philippe Perron. All rights reserved.
//

#import "NSArray+WithCVector.h"

@implementation NSArray (WithCVector)

+ (NSArray*)arrayWithCVector:(char**)vec ofSize:(int)size
{
	NSMutableArray * buildArray = [NSMutableArray array];
	for (int i; i < size; i++) {
		if (vec[i] != NULL) {
			[buildArray addObject:[NSString stringWithUTF8String:vec[i]]];
		} else {
			[buildArray addObject:nil];
		}

	}
	return [NSArray arrayWithArray:buildArray];
}

- (const char**)cVector
{
	char ** vector = malloc(sizeof(char*) * (int)[self count]);
	NSEnumerator * e = [self objectEnumerator];
	id o;
	
	while (o = [e nextObject]) {
		int i = (int)[self indexOfObject:o];
		vector[i] = (char*)[o UTF8String];
	}
	
	return (const char**)vector;
}

@end
