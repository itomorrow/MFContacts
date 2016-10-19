//
//  ASAddressBookAccessRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <AddressBook/ABAddressBook.h>
#import "MFAddressBookAccessRoutine.h"
#import "MFContactsModels.h"

@implementation MFAddressBookAccessRoutine

#pragma mark - public

+ (MFAddressBookAccess)accessStatus
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status)
    {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            return MFAddressBookAccessDenied;

        case kABAuthorizationStatusAuthorized:
            return MFAddressBookAccessGranted;

        default:
            return MFAddressBookAccessUnknown;
    }
}

- (void)requestAccessWithCompletion:(void (^)(BOOL granted, NSError *error))completionBlock
{
    if (self.wrapper)
    {
        ABAddressBookRequestAccessWithCompletion(self.wrapper.ref, ^(bool granted, CFErrorRef error)
        {
            completionBlock ? completionBlock(granted, (__bridge NSError *)error) : nil;
        });
    }
}

@end
