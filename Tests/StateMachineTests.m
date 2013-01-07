//
//  StateMachineTests.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@protocol ToMakeTestCompile <NSObject>

- (void)becomes:(NSString *)state;
- (void)equals:(NSString *)state;

@end

DEFINE_FUNCTIONAL_TEST_CASE(StateMachineTests) {
  LRMockyStateMachine *readiness;
}

- (void)setUp
{
  [super setUp];
  
  readiness = [context states:@"readiness"];
}

- (void)xtestCanConstrainExpectationsToOccurWithinGivenState
{
  [context check:^{
    [allowing(testObject) doSomethingElse]; [thenStateOf(readiness) becomes:@"ready"];
    [[expectThat(testObject) receives] doSomething]; [whenStateOf(readiness) equals:@"ready"];
  }];
  
  [testObject doSomething];
  
  [context assertSatisfied];
  
  assertThat(testCase, failedWithNumberOfFailures(1));
}

//- (void)testAllowsExpectationsToOccurInCorrectState
//{
//  [context checking:^(that){
//    [allowing(testObject) doSomethingElse]; then([readiness becomes:@"ready"]);
//    [oneOf(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
//  }];
//  
//  [testObject doSomethingElse];
//  [testObject doSomething];
//  
//  assertContextSatisfied(context);
//  
//  assertThat(testCase, passed());
//}
//
//- (void)testCanStartInASpecificState
//{
//  [readiness startsAs:@"ready"];
//
//  [context checking:^(that){
//    [allowing(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
//  }];
//  
//  [testObject doSomething];
//  
//  assertContextSatisfied(context);
//  
//  assertThat(testCase, passed());
//}
//
//- (void)testCanConstraintExpectationsToStatesTriggeredByBlocks
//{
//  [context checking:^(that){
//    [allowing(testObject) doSomethingWithBlock:anyBlock()]; then([readiness becomes:@"ready"]); andThen(performBlockArguments);
//    [oneOf(testObject) doSomething]; when([readiness hasBecome:@"ready"]);
//  }];
//  
//  [testObject doSomethingWithBlock:^{
//    [testObject doSomething];
//  }];
//  
//  assertContextSatisfied(context);
//
//  assertThat(testCase, passed());  
//}

END_TEST_CASE
