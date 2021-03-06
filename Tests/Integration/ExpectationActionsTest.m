//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(ExpectationActionsTest)

- (void)testCanReturnAnObjectFromAnExpectedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context check:^{
    [[expectThat(testObject) receives] returnSomething]; [then returns:expectedObject];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testCanReturnPrimitivesFromMethodsUsingUnboxedValues
{
  [context check:^{
    [[expectThat(testObject) receives] returnSomeValue]; [then returnsValue:(void *)10];
  }];

  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testCanReturnPrimitivesFromMethodsUsingBoxedValues
{
  [context check:^{
    [[expectThat(testObject) receives] returnSomeValue]; [then returns:@10];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testCanPerformCustomBlocksAfterExpectedInvocation;
{
  __block BOOL blockWasPerformed = NO;
  
  [context check:^{
    [[expectThat(testObject) receives] doSomething]; [then performsBlock:^(NSInvocation *invocation){
      blockWasPerformed = YES;
    }];
  }];
  
  [testObject doSomething];
  
  assertTrue(blockWasPerformed);
}

- (void)testCanModifyInvocationFromWithinCustomBlock
{
  __block id expectedReturnValue = @"anything";
  
  [context check:^{
    [[expectThat(testObject) receives] returnSomething]; [then performsBlock:^(NSInvocation *invocation){
      [invocation setReturnValue:&expectedReturnValue];
    }];
  }];
  
  id returnValue = [testObject returnSomething];
  
  assertThat(returnValue, equalTo(expectedReturnValue));
}

- (void)testMocksCanReturnDifferentValuesOnConsecutiveCalls;
{
  [context check:^{
    [[[expectThat(testObject) receivesAtLeast:3] of] returnSomeValue]; [then onConsecutiveCalls:^(id actions) {
      [actions returns:@10];
      [actions returns:@20];
      [actions returns:@30];
    }];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
}

#if !(TARGET_IPHONE_SIMULATOR)
- (void)testMocksCanThrowAnException;
{
  [context check:^{
    [allowing(testObject) doSomething]; [then raisesException:[NSException exceptionWithName:@"Test Exception" reason:nil userInfo:nil]];
  }];
  
  /**
   * this will only pass using the iOS 4.0 Device SDK, it currently fails
   * with the simulator SDK due to a runtime bug. rdar://8081169
   * also see: http://openradar.appspot.com/8081169
   * filed dupe: http://openradar.appspot.com/
   */
  
  @try {
    [testObject doSomething];
    STFail(@"Exception expected but none was thrown");
  }
  @catch (NSException *exception) {
    assertThat([exception name], equalTo(@"Test Exception"));
  }
}
#endif

- (void)testMocksCanPerformMultipleActions;
{
  __block BOOL calledSecondAction = NO;

  [context check:^{
    [allowing(testObject) returnSomething]; [then doesAllOf:^(id<LRExpectationActionSyntax> actions) {
      [actions returns:@"return value"];
      [actions performsBlock:^(NSInvocation *unused) {
        calledSecondAction = YES;
      }];
    }];
  }];

  assertThat([testObject returnSomething], equalTo(@"return value"));
  assertTrue(calledSecondAction);
}

END_TEST_CASE
