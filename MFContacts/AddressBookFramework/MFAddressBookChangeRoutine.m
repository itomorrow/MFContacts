//
//  ASAddressBookChangeRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import "MFAddressBookChangeRoutine.h"
#import "MFContactsModels.h"

void MFAddressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef __unused info, void *context);

@implementation MFAddressBookChangeRoutine

#pragma mark - life cycle

- (instancetype)initWithAddressBookRefWrapper:(MFAddressBookRefWrapper *)wrapper
{
    self = [super initWithAddressBookRefWrapper:wrapper];
    if (wrapper)
    {
        [self registerExternalChangeCallback];
    }
    return self;
}

- (void)dealloc
{
    if (self.wrapper)
    {
        [self unregisterExternalChangeCallback];
    }
}

#pragma mark - private

- (void)registerExternalChangeCallback
{
    ABAddressBookRegisterExternalChangeCallback(self.wrapper.ref, ASAddressBookExternalChangeCallback,
                                                (__bridge void *)(self));
}

- (void)unregisterExternalChangeCallback
{
    ABAddressBookUnregisterExternalChangeCallback(self.wrapper.ref, ASAddressBookExternalChangeCallback,
                                                  (__bridge void *)(self));
}

#pragma mark - external change callback

void ASAddressBookExternalChangeCallback(ABAddressBookRef addressBookRef, CFDictionaryRef __unused info, void *context)
{
    ABAddressBookRevert(addressBookRef);
    MFAddressBookChangeRoutine *routine = (__bridge MFAddressBookChangeRoutine *)(context);
    [routine.delegate addressBookDidChange];
}

@end
