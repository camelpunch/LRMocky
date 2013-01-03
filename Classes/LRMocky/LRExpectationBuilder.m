//
//  LRExpectationBuilder.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRInvocationExpectation.h"
#import "LRExpectationCardinality.h"
#import "LRMockyStates.h"
#import "LRPerformBlockAction.h"
#import "NSInvocation+OCMAdditions.h"

@interface LRExpectationBuilder ()
@property (nonatomic, retain) LRInvocationExpectation *currentExpecation;
@property (nonatomic, readonly) OLD_LRImposterizer *imposterizer;

- (id)initWithMockery:(LRMockery *)aMockery;
- (void)actAsImposterForMockObject:(OLD_LRMockObject *)mock;

@end

@implementation LRExpectationBuilder {
  LRMockery *_mockery;
  OLD_LRImposterizer *_imposterizer;
  id _capturingImposter;
}

#pragma mark - Global expectation builder access

static LRExpectationBuilder *__currentExpectationBuilder = nil;

+ (void)buildExpectationsWithBlock:(dispatch_block_t)expectationBlock inContext:(LRMockery *)context
{
  __currentExpectationBuilder = [[self alloc] initWithMockery:context];
  expectationBlock();
}

+ (LRExpectationBuilder *)currentExpectationBuilder
{
  return __currentExpectationBuilder;
}

//+ (id)expectThat:(id)object
//{
//  return [__globalExpectationBuilder oneOf:object];
//}
//
//+ (id)allow:(id)object
//{
//  return [__globalExpectationBuilder allowing:object];
//}
//
//+ (void)setCardinalityForCurrentExpectation:(id<LRExpectationCardinality>)cardinality
//{
//  [__globalExpectationBuilder setCardinalityForCurrentExpectation:cardinality];
//}

#pragma mark -

- (id)initWithMockery:(LRMockery *)aMockery;
{
  if (self = [super init]) {
    _mockery = [aMockery retain];
  }
  return self;
}

- (void)dealloc;
{
  [_imposterizer release];
  [_mockery release];
  [super dealloc];
}

- (id<LRExpectation>)expectation
{
  return self.currentExpecation;
}

#pragma mark - Fluent Interface

- (id)setExpectationTarget:(id)object
{
  if (![object conformsToProtocol:@protocol(LRCaptureControl)]) {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Can only set expectations on mock objects!"
                                 userInfo:nil];
  }
  self.currentExpecation = [self expectationForObject:object];
  
  _capturingImposter = [(id<LRCaptureControl>)object captureExpectationTo:(id<LRExpectationCapture>)self];
  
  return self;
}

- (id)receives;
{
  return _capturingImposter;
}

- (id)receives:(id<LRExpectationCardinality>)cardinality
{
  self.currentExpecation.cardinality = cardinality;
  return _capturingImposter;
}

- (id)neverReceives
{
  [self receives:LRM_exactly(0)];
  return _capturingImposter;
}

- (id)of
{
  return _capturingImposter;
}

- (void)requiresState:(LRMockyState *)state;
{
  self.currentExpecation.requiredState = state;
}

- (void)shouldTransitionToState:(LRMockyState *)state;
{
  [self.currentExpecation addAction:[LRMockyStateTransitionAction transitionToState:state]];
}

- (id)then:(id)action
{
  if ([action conformsToProtocol:@protocol(LRExpectationAction)]) {
    [self.currentExpecation addAction:action];
  }
  else {
    // we will *assume* it's a block - not very safe, we'll have
    // to rely on clients of this method to do the right thing.
    
    LR_invocationActionBlock actionBlock = (LR_invocationActionBlock)action;
    action = [[LRPerformBlockAction alloc] initWithBlock:actionBlock];
    [self.currentExpecation addAction:action];
  }
  return self;
}

#pragma mark - LRExpectationCapture

- (void)createExpectationFromInvocation:(NSInvocation *)invocation
{
  self.currentExpecation.invocation = invocation;
  [_mockery addExpectation:self.currentExpecation];
}

#pragma mark - Private

- (LRInvocationExpectation *)expectationForObject:(id)object
{
  return [LRInvocationExpectation expectationWithObject:object];
}

@end
