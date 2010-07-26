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

@interface LRExpectationBuilder : LRClassImposter {
  LRMockery *mockery;
  Class mockedClass;
  id<LRExpectation> currentExpectation;
}
+ (id)builderInContext:(LRMockery *)context;
- (id)initWithMockery:(LRMockery *)aMockery;
- (id)oneOf:(id)mockObject;
- (id)will:(id<LRExpectationAction>)action;
- (id)allowing:(id)mockObject;
@end


#ifdef LRMOCKY_SUGAR
#define it builder
#define oneOf(arg)    [builder oneOf:arg]
#define allowing(arg) [builder allowing:arg]
#endif
