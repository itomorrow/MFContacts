//
//  ASAddressBookBaseRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFAddressBookRefWrapper;

@interface MFAddressBookBaseRoutine : NSObject

@property (nonatomic, readonly) MFAddressBookRefWrapper *wrapper;

- (instancetype)initWithAddressBookRefWrapper:(MFAddressBookRefWrapper *)wrapper;

@end
