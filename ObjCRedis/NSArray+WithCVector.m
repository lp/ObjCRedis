//
//  NSArray+WithCVector.m
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-24.
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
