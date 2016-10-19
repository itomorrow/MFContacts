//
//  MFThread.h
//  AddressBook
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFThread : NSThread

- (void)dispatchAsync:(void (^)())block;
- (void)dispatchSync:(void (^)())block;

@end
