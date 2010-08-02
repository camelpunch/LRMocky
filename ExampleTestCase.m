//
//  ExampleTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 28/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR
#define HC_SHORTHAND

#import <SenTestingKit/SenTestingKit.h>
#import "OCHamcrest.h"
#import "LRMocky.h"

@interface ExampleTestCase : SenTestCase
{}
@end

@implementation ExampleTestCase

- (void)testSuccessfulMocking
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];

  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  assertContextSatisfied(context);
}

- (void)testFailedMocking 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString lowercaseString];
  
  assertContextSatisfied(context);
}


- (void)testSuccessfulMockingWithMultipleCallsExpected
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[atLeast(2) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  
  assertContextSatisfied(context);
}

- (void)testFailedMockingWithMultipleCallsExpected
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[between(2, 4) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  assertContextSatisfied(context);
}

- (void)testSuccessfulMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"super"];
  assertContextSatisfied(context);
}

- (void)testFailedMockingWithHamcrest 
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:with(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"not super"];
  assertContextSatisfied(context);
}

- (void)testSuccessfulMockWithReturnValue
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(returnsObject(@"FOOBAR"));
  }];
  
  NSString *returnedValue = [myMockString uppercaseString];
  assertContextSatisfied(context);

  assertThat(returnedValue, equalTo(@"FOOBAR"));
}

- (void)testSuccessfulMockWithPerformedBlock
{
  LRMockery *context = [LRMockery mockeryForTestCase:self];
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  __block id outsideTheBlock = nil;
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(performsBlock(^(NSInvocation *invocation) {
      outsideTheBlock = @"FOOBAR";
    }));
  }];
  
  [myMockString uppercaseString];
  assertContextSatisfied(context);
  
  assertThat(outsideTheBlock, equalTo(@"FOOBAR"));
}

@end
