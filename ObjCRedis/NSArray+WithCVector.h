//
//  NSArray+WithCVector.h
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-24.
//  Copyright 2010 Louis-Philippe Perron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WithCVector)

+ (NSArray*)arrayWithCVector:(char**)vec ofSize:(int)size;
- (const char**)cVector;

@end
