//
//  StateMachineTests.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface StateMachineTests : FunctionalMockeryTestCase
{
  LRMockyStateMachine *readiness;
}
@end

@implementation StateMachineTests

- (void)setUp
{
  [super setUp];
  
  readiness = [[context states:@"readiness"] retain];
}

- (void)testCanConstrainExpectationsToOccurWithinAGivenState
{
  [context checking:^(that){
    [allowing(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
    [allowing(testObject) doSomethingElse]; then([readiness becomes:@"ready"]);
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

- (void)testAllowsExpectationsToOccurInCorrectState
{
  [context checking:^(that){
    [allowing(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
    [allowing(testObject) doSomethingElse]; then([readiness becomes:@"ready"]);
  }];
  
  [testObject doSomethingElse];
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanStartInASpecificState
{
  [readiness startsAs:@"ready"];

  [context checking:^(that){
    [allowing(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

@end
