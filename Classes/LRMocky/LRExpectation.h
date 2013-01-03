//
//  LRExpectation.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationAction.h"
#import "LRDescribable.h"

extern NSString *const LRMockyExpectationError;

@protocol LRExpectation <NSObject, LRDescribable>

- (BOOL)isSatisfied;
- (BOOL)matches:(NSInvocation *)invocation;
- (void)invoke:(NSInvocation *)invocation;

@optional
- (void)addAction:(id<LRExpectationAction>)action;
- (BOOL)calledWithInvalidState;

@end
