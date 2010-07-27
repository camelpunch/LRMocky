//
//  LRExpectationCardinality.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationCardinality.h"

@implementation LREqualToCardinality

- (id)initWithInt:(int)anInt;
{
  if (self = [super init]) {
    equalToInt = anInt;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations == equalToInt;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"equalTo(%d)", equalToInt];
}

@end

id<LRExpectationCardinality> LRM_expectExactly(int anInt)
{
  return [[[LREqualToCardinality alloc] initWithInt:anInt] autorelease];
}

@implementation LRAtLeastCardinality

- (id)initWithMinimum:(int)theMinimum;
{
  if (self = [super init]) {
    minimum = theMinimum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations >= minimum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"atLeast(%d)", minimum];
}

@end

id<LRExpectationCardinality> LRM_atLeast(int anInt)
{
  return [[[LRAtLeastCardinality alloc] initWithMinimum:anInt] autorelease];
}

@implementation LRAtMostCardinality

- (id)initWithMaximum:(int)theMaximum;
{
  if (self = [super init]) {
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations <= maximum;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"atMost(%d)", maximum];
}

@end

id<LRExpectationCardinality> LRM_atMost(int anInt)
{
  return [[[LRAtMostCardinality alloc] initWithMaximum:anInt] autorelease];
}

@implementation LRBetweenCardinality

- (id)initWithMinimum:(int)theMinimum andMaximum:(int)theMaximum;
{
  if (self = [super init]) {
    minimum = theMinimum;
    maximum = theMaximum;
  }
  return self;
}

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return (numberOfInvocations >= minimum && numberOfInvocations <= maximum);
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"between(%d and %d)", minimum, maximum];
}

@end

id<LRExpectationCardinality> LRM_between(int min, int max)
{
  return [[[LRBetweenCardinality alloc] initWithMinimum:min andMaximum:max] autorelease];
}

@implementation LRNeverCardinality

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return numberOfInvocations == 0;
}

- (NSString *)description
{
  return @"never";
}

@end

id<LRExpectationCardinality> LRM_never()
{
  return [[[LRNeverCardinality alloc] init] autorelease];
}

@implementation LRAllowingCardinality

- (BOOL)satisfiedBy:(int)numberOfInvocations
{
  return YES;
}

- (NSString *)description
{
  return @"any number of times";
}

@end

id<LRExpectationCardinality> LRM_allowing()
{
  return [[[LRAllowingCardinality alloc] init] autorelease];
}
