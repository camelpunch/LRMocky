//
//  LRExpectationBuilder.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRInvocationExpectation.h"
#import "LRExpectationCardinality.h"
#import "LRMockyStates.h"
#import "LRPerformBlockAction.h"
#import "LRAllParametersMatcher.h"
#import "NSInvocation+Conveniences.h"

@interface LRInvocationExpectationBuilder ()
@property (nonatomic, readonly) LRInvocationExpectation *expectation;
@property (nonatomic, strong) id expectationCapturingImposter;
@end

@implementation LRInvocationExpectationBuilder

- (id)init
{
  if ((self = [super init])) {
    _expectation = [[LRInvocationExpectation alloc] init];
  }
  return self;
}

- (void)buildExpectations:(id<LRExpectationCollector>)expectationCollector
{
  [expectationCollector addExpectation:self.expectation];
}

#pragma mark - Builder API

- (void)setTarget:(id)target
{
  if (![target conformsToProtocol:@protocol(LRCaptureControl)]) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Can only set expectations on mock objects!"
                                 userInfo:nil];
  }
  
  self.expectation.target = target;
}

- (void)setCardinality:(id<LRExpectationCardinality>)cardinality
{
  self.expectation.cardinality = cardinality;
}

- (id)captureExpectedObject
{
  id<LRCaptureControl> target = self.expectation.target;
  self.expectationCapturingImposter = [target captureExpectationTo:self];
  return self.expectationCapturingImposter;
}

#pragma mark - Syntatic sugar

- (id)of
{
  return self.expectationCapturingImposter;
}

#pragma mark - Capturing expectations

- (void)createExpectationFromInvocation:(NSInvocation *)invocation
{
  self.expectation.selector = invocation.selector;
  self.expectation.parametersMatcher = [[LRAllParametersMatcher alloc] initWithParameters:invocation.argumentsArray];
}

@end
