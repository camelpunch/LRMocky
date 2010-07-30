//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposter.h"
#import "LRExpectation.h"

@class LRMockObject;
@class LRMockery;
@class LRInvocationExpectation;
@class LRMockyState;

@interface LRExpectationBuilder : LRClassImposter {
  LRMockery *mockery;
  Class mockedClass;
  LRInvocationExpectation *currentExpectation;
}
+ (id)builderInContext:(LRMockery *)context;
- (id)initWithMockery:(LRMockery *)aMockery;
- (id)receives; // syntatic sugar
- (id)oneOf:(id)mockObject;
- (id)exactly:(int)numberOfTimes of:(id)mockObject;
- (id)atLeast:(int)minimum of:(id)mockObject;
- (id)atMost:(int)maximum of:(id)mockObject;
- (id)between:(int)minimum and:(int)maximum of:(id)mockObject;
- (id)will:(id<LRExpectationAction>)action;
- (id)allowing:(id)mockObject;
- (id)never:(id)mockObject;
- (void)transitionsToState:(LRMockyState *)state;
- (void)requiresState:(LRMockyState *)state;
@end


#ifdef LRMOCKY_SUGAR
#define that            LRExpectationBuilder *builder
#define it               builder
#define andThen(action) [builder will:action]
#define oneOf(arg)      [builder oneOf:arg]
#define allowing(arg)   [builder allowing:arg]
#define never(arg)      [builder never:arg]
#define exactly(x)       builder exactly:x
#define atLeast(x)       builder atLeast:x
#define atMost(x)        builder atMost:x
#define between(x, y)    builder between:x and:y
#define then(state)     [builder transitionsToState:state]
#define when(state)     [builder requiresState:state];
#endif
