//
//  NSSet+WithCVector.h
//  ObjCRedis
//
//  Created by Louis-Philippe on 10-09-26.
//  Copyright 2010 Louis-Philippe Perron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (WithCVector)

+ (NSSet*)setWithCVector:(char**)vec ofSize:(int)size;
- (const char**)cVector;

@end
