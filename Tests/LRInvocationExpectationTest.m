//
//  LRInvocationExpectationTest.m
//  Mocky
//
//  Created by Luke Redpath on 04/01/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TestHelper.h"
#import "HCBlockMatcher.h"
#import "LRInvocationExpectation.h"
#import "LRAllParametersMatcher.h"
#import "NSInvocation+Conveniences.h"

#pragma mark - Helper functions

id anyObject(void);

NSInvocation *invocationForSelectorOn(id object, SEL selector);
NSInvocation *invocationWithArguments(id object, SEL selector, NSArray *args);
NSInvocation *anyInvocationOn(id object);

#pragma mark -

DEFINE_TEST_CASE(LRInvocationExpectationTest) {
  LRInvocationExpectation *expectation;
}

- (void)setUp
{
  expectation = [[LRInvocationExpectation alloc] init];
}

- (void)testMatchesAnyInvocationByDefault
{
  assertTrue([expectation matches:anyInvocationOn(anyObject())]);
}

- (void)testCanConstrainToInvocationsOnSpecificTarget
{
  id targetObject = anyObject();

  expectation.target = targetObject;
  
  assertTrue([expectation matches:anyInvocationOn(targetObject)]);
  assertTrue(![expectation matches:anyInvocationOn(anyObject())]);
}

- (void)testCanConstrainToInvocationsOnSpecificSelector
{
  SEL selectorOne = @selector(description);
  SEL selectorTwo = @selector(init);

  expectation.selector = selectorOne;
  
  assertTrue([expectation matches:invocationForSelectorOn(anyObject(), selectorOne)]);
  assertTrue(![expectation matches:invocationForSelectorOn(anyObject(), selectorTwo)]);
}

- (void)testCanConstrainToInvocationsToSpecificMethodArguments
{
  expectation.parametersMatcher = [[LRAllParametersMatcher alloc] initWithParameters:@[@"expected"]];

  assertTrue([expectation matches:invocationWithArguments(anyObject(), @selector(doSomethingWithObject:), @[@"expected"])]);
  assertTrue(![expectation matches:invocationWithArguments(anyObject(), @selector(doSomethingWithObject:), @[@"unexpected"])]);
}

- (void)testCanConstrainToInvocationsWithNonObjectArguments
{
  expectation.parametersMatcher = [[LRAllParametersMatcher alloc] initWithParameters:@[equalToInteger(123)]];
  
  NSInvocation *theInvocation = invocationForSelectorOn(anyObject(), @selector(doSomethingWithInt:));
  
  NSInteger argumentOne = 123;
  [theInvocation setArgument:&argumentOne atIndex:2];
  
  assertTrue([expectation matches:theInvocation]);
  
  NSInteger argumentTwo = 456;
  [theInvocation setArgument:&argumentTwo atIndex:2];
  
  assertTrue(![expectation matches:theInvocation]);
}

END_TEST_CASE

#pragma mark -

id anyObject(void) {
  return [[SimpleObject alloc] init];
}

NSInvocation *invocationForSelectorOn(id object, SEL selector) {
  NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  invocation.target = object;
  invocation.selector = selector;
  return invocation;
}

NSInvocation *invocationWithArguments(id object, SEL selector, NSArray *args) {
  NSInvocation *invocation = invocationForSelectorOn(object, selector);
  NSUInteger numberOfArguments = invocation.numberOfActualArguments;
  
  if (numberOfArguments == 0) return invocation;
  
  for (int i = 0; i < numberOfArguments; i++) {
    if (i < args.count) {
      [invocation putObject:args[i] asArgumentAtIndex:i];
    }
    else {
      [invocation putObject:[NSNull null] asArgumentAtIndex:i];
    }
  }
  return invocation;
}

NSInvocation *anyInvocationOn(id object) {
  return invocationForSelectorOn(object, @selector(description));
}
