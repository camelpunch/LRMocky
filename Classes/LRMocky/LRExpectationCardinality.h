//
//  LRExpectationCardinality.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LREqualToCardinality : NSObject <LRExpectationCardinality> {
  int equalToInt;
}
- (id)initWithInt:(int)anInt;
@end

id<LRExpectationCardinality> LRM_expectExactly(int anInt);

@interface LRAtLeastCardinality : NSObject <LRExpectationCardinality> {
  int minimum;
}
- (id)initWithMinimum:(int)theMinimum;
@end

id<LRExpectationCardinality> LRM_atLeast(int anInt);

@interface LRAtMostCardinality : NSObject <LRExpectationCardinality> {
  int maximum;
}
- (id)initWithMaximum:(int)theMaximum;
@end

id<LRExpectationCardinality> LRM_atMost(int anInt);

@interface LRBetweenCardinality : NSObject <LRExpectationCardinality> {
  int minimum;
  int maximum;
}
- (id)initWithMinimum:(int)theMinimum andMaximum:(int)theMaximum;
@end

id<LRExpectationCardinality> LRM_between(int min, int max);

@interface LRNeverCardinality : NSObject <LRExpectationCardinality> 
{}
@end

id<LRExpectationCardinality> LRM_never();

@interface LRAllowingCardinality : NSObject <LRExpectationCardinality>
{}
@end

id<LRExpectationCardinality> LRM_allowing();
