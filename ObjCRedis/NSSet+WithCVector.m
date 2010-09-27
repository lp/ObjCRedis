//
//  NSSet+WithCVector.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-26.
//  Copyright 2010 Louis-Philippe Perron. All rights reserved.
//

#import "NSSet+WithCVector.h"
#import "NSArray+WithCVector.h"

@implementation NSSet (WithCVector)

+ (NSSet*)setWithCVector:(char**)vec ofSize:(int)size
{
	return [NSSet setWithArray:[NSArray arrayWithCVector:vec ofSize:size]];
}

- (const char**)cVector
{	
	return [[self allObjects] cVector];
}


@end
