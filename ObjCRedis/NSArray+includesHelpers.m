//
//  NSArray+includesHelpers.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-25.
//  Copyright 2010 Louis-Philippe Perron. All rights reserved.
//

#import "NSArray+includesHelpers.h"

@implementation NSArray (includesHelpers)

- (NSNumber*)includes:(NSArray*)items {
	BOOL (^mustSatisfy)(id obj, NSUInteger idx, BOOL *stop);
	mustSatisfy = ^ (id obj, NSUInteger idx, BOOL *stop) {
		return [items containsObject:obj];
	};
	
	if ([[items indexesOfObjectsPassingTest:mustSatisfy] count] > 0) {
		return [NSNumber numberWithBool:YES]; }
	else { return [NSNumber numberWithBool:NO]; }
}

@end
