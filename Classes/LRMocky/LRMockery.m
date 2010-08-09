//
//  LRMockery.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockery.h"
#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRUnexpectedInvocation.h"
#import "LRMockyStates.h"
#import "LRExpectationMessage.h"

@implementation LRMockery

+ (id)mockeryForTestCase:(id)testCase;
{
  // support SenTestCase out of the box
  return [self mockeryForSenTestCase:(SenTestCase *)testCase];
}

+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;
{
  LRSenTestCaseNotifier *notifier = [LRSenTestCaseNotifier notifierForTestCase:testCase];
  return [[[self alloc] initWithNotifier:notifier] autorelease];
}

- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;
{
  if (self = [super init]) {
    testNotifier = [aNotifier retain];
    expectations = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [testNotifier release];
  [expectations release];
  [super dealloc];
}

- (id)mock:(Class)klass;
{
  return [LRMockObject mockForClass:klass inContext:self]; 
}

- (id)mock:(Class)klass named:(NSString *)name;
{
  LRMockObject *mock = [self mock:klass];
  mock.name = name;
  return mock;
}

- (LRMockyStateMachine *)states:(NSString *)name;
{
  return [[[LRMockyStateMachine alloc] initWithName:name] autorelease];
}

- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;
{
  LRMockyStateMachine *stateMachine = [self states:name];
  [stateMachine startsAs:defaultState];
  return stateMachine;
}

- (void)checking:(void (^)(id will))expectationBlock;
{
  expectationBlock([LRExpectationBuilder builderInContext:self]);
}

NSString *failureFor(id<LRDescribable> expectation) {
  LRExpectationMessage *errorMessage = [[[LRExpectationMessage alloc] init] autorelease];
  [expectation describeTo:errorMessage];
  return [errorMessage description];
}

- (void)assertSatisfied
{
  return [self assertSatisfiedInFile:nil lineNumber:0];
}

- (void)assertSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation isSatisfied] == NO) {
      [testNotifier notifiesFailureWithDescription:failureFor(expectation) inFile:fileName lineNumber:lineNumber];
    }
  }
}

- (void)addExpectation:(id<LRExpectation>)expectation;
{
  [expectations addObject:expectation];
}

- (void)dispatchInvocation:(NSInvocation *)invocation;
{
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation matches:invocation]) {
      return [expectation invoke:invocation];
    }
  }
  LRUnexpectedInvocation *unexpectedInvocation = [LRUnexpectedInvocation unexpectedInvocation:invocation];
  unexpectedInvocation.mockObject = [invocation target];
  [expectations addObject:unexpectedInvocation];
}

- (void)reset;
{
  [expectations removeAllObjects];
}

@end

void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber)
{
  [context assertSatisfiedInFile:fileName lineNumber:lineNumber];
}

