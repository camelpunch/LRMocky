//
//  LRPerformBlockAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

typedef void (^LRInvocationActionBlock)(NSInvocation *);

@interface LRPerformBlockAction : NSObject <LRExpectationAction> {
  LRInvocationActionBlock block;
}
- (id)initWithBlock:(LRInvocationActionBlock)theBlock;
@end

LRPerformBlockAction *LRA_performBlock(LRInvocationActionBlock theBlock);

#ifdef LRMOCKY_SHORTHAND
#define performBlock  LRA_performBlock
#define performsBlock LRA_performBlock
#endif
