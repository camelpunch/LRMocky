//
//  HCBlockMatcher.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "HCBlockMatcher.h"
#import <OCHamcrest/HCDescription.h>

@implementation HCBlockMatcher

+ (id)matcherWithBlock:(HCBlockMatcherBlock)block description:(NSString *)aDescription;
{
  return [[self alloc] initWithBlock:block description:aDescription];
}

- (id)initWithBlock:(HCBlockMatcherBlock)aBlock description:(NSString *)aDescription;
{
  if (self = [super init]) {
    block = [aBlock copy];
    description = [aDescription copy];
  }
  return self;
}


- (BOOL)matches:(id)actual
{
  return block(actual);
}

- (void)describeTo:(id <HCDescription>)_description
{
  [_description appendText:description];
}

@end

#ifdef __cplusplus
extern "C" {
#endif
  id<HCMatcher> HC_satisfiesBlock(NSString *description, HCBlockMatcherBlock block)
  {
    return [HCBlockMatcher matcherWithBlock:block description:description];
  }
#ifdef __cplusplus
}
#endif
