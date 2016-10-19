//
//  MFThread.m
//  AddressBook
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//


#import "MFThread.h"

@implementation MFThread

#pragma mark - public

- (void)dispatchAsync:(void (^)())block
{
    [self performSelector:@selector(performBlock:) onThread:self withObject:block waitUntilDone:NO];
}

- (void)dispatchSync:(void (^)())block
{
    [self performSelector:@selector(performBlock:) onThread:self withObject:block waitUntilDone:YES];
}

#pragma mark - override

- (void)main
{
    while (!self.cancelled)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture];
        }
        
    }
}

#pragma mark - private

- (void)performBlock:(void (^)())block
{
    block();
}

@end
