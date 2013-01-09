//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

DEFINE_FUNCTIONAL_TEST_CASE(SimpleExpectationTests)

- (void)testCanExpectSingleMethodCallAndPass;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

//- (void)testSimpleExpectationWithNewSyntax
//{
//  [context checking:^{
//    // simple expectation
//    [expectThat(testObject).receives doSomething];
//    
//    // with arguments
//    [expectThat(testObject).receives doSomethingWithArgument:@"arg"];
//
//    // expectation with cardinality
//    [[expectThat(testObject).receives doSomething] times:1];
//    [[expectThat(testObject).receives doSomething] atLeast:1];
//    [[expectThat(testObject).receives doSomething] never];
//    
//    // syntatic sugar for common cardinality options
//    [[expectThat(testObject).receives doSomething] once];
//    [expectThat(testObject.neverReceives doSomething)];
//    [allow(testObject).receives doSomething];
//    
//    // expectation actions
//    [[[expectThat(testObject).receives doSomething] then] returns:@"result"];
//    [[[expectThat(testObject).receives doSomething] then] raises:anException];
//    [[[expectThat(testObject).receives doSomething] then] performs:^{ /* some code */ }];
//    
//    // sequences
//    id sequence = [context sequence:@"some sequence"];
//    
//    [[expectThat(testObject).receives doSomething] inSequence:sequence];
//    [[expectThat(testObject).receives doSomethingElse] inSequence:sequence];
//    
//    // states
//    id power = [[context state:@"power"] startsAs:@"off"];
//    
//    [[[expectThat(testObject).receives doSomething] when:power is:@"on"] then:power is:@"off"];
//    [[[expectThat(testObject).receives doSomething] when:power is:@"off"]];
//  }];
//  
//  // do things with testObject
//  
//  // check if the context is satisfied 
//  [context assertSatisfied];
//  
//  // or use your own matcher library (e.g. expecta)
//  expect(context).isSatisfied();
//  
//  // wait for asynchronous behaviour to complete?
//  [context assertEventuallySatisfied];
//  
//  // or some kind of expecta async syntax for predicates?
//  expect(context).eventually.isSatisfied();
//  
//  // or perhaps
//  expect(context).will.beSatisfied();
//}

- (void)testCanExpectSingleMethodCallAndFail;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomething];
  }];

  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly once but received it 0 times.", testObject]));
}

- (void)testFailsWhenUnexpectedMethodIsCalled;
{
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Unexpected method doSomething called on %@", testObject]));
}

- (void)testCanAllowSingleMethodCallAndPassWhenItIsCalled;
{
  [context check:^{
    [allowing(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  [context check:^{
    [allowing(testObject) doSomething];
  }];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndPassWhenTheCorrectParameterIsUsed;
{
  [context check:^{
    [[expectThat(testObject) receives] returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"one"];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenTheWrongParameterIsUsed;
{
  [context check:^{
    [[expectThat(testObject) receives] returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"two"];
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive returnSomethingForValue: with arguments: [\"one\"] exactly once but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenAtLeastOneParameterIsWrong;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWith:@"foo" andObject:@"bar"];
  }];
  
  [testObject doSomethingWith:@"foo" andObject:@"qux"];
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWith:andObject: with arguments: [\"foo\", \"bar\"] exactly once but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndPass;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithInt:20];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWitBoolParametersAndPass;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithBool:YES];
  }];
  
  [testObject doSomethingWithBool:YES];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndFail;
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithInt:10];
  }];
  
  [testObject doSomethingWithInt:20];
  [context assertSatisfied];

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithInt: with arguments: [<10>] exactly once but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallsWithBlockArgumentsAndPass;
{
  id mockArray = [context mock:[NSArray class]];
 
  [context check:^{
    [[expectThat(mockArray) receives] indexesOfObjectsPassingTest:(__bridge BOOL (^)(__strong id, NSUInteger, BOOL *))(anyBlock())];
  }];
  
  [(NSArray *)mockArray indexesOfObjectsPassingTest:^(id object, NSUInteger idx, BOOL *stop) { return YES; }];
}

- (void)testCanExpectMethodCallsWithAnythingAndPassWithGivenNil
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:anything()];
  }];
  
  [testObject doSomethingWithObject:nil];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallsWithNilParameter
{
  [context check:^{
    [[expectThat(testObject) receives] doSomethingWithObject:nilValue()];
  }];
  
  [testObject doSomethingWithObject:nil];
  [context assertSatisfied];
  
  assertThat(testCase, passed());
}

//- (void)testCanExpectMethodCallsWithBlockArgumentsWithObjectAndPass;
//{
//  [context check:^{
//    [[expectThat(testObject) receives] doSomethingWithBlockThatYields:anyBlock()]; andThen(performBlockArgumentsWithObject(@"some string"));
//  }];
//  
//  [testObject doSomethingWithBlockThatYields:^(id object) {
//    assertThat(object, is(equalTo(@"some string")));
//  }];
//}

- (void)testCanResetTheMockery
{
  [context check:^{
    [[expectThat(testObject) receives] doSomething];
  }];
  
  [context reset];
  [context assertSatisfied];

  assertThat(testCase, passed());
}

END_TEST_CASE
