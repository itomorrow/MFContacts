//
//  MFContactsAccessRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <AddressBook/ABAddressBook.h>
#import "MFContactsAccessRoutine.h"

@implementation MFContactsAccessRoutine

#pragma mark - public

+ (MFAddressBookAccess)accessStatus
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status)
    {
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted:
            return MFAddressBookAccessDenied;

        case CNAuthorizationStatusAuthorized:
            return MFAddressBookAccessGranted;

        default:
            return MFAddressBookAccessUnknown;
    }
}

- (void)requestAccessWithCompletion:(void (^)(BOOL granted, NSError *error))completionBlock
{
    if (self.contactStore) {
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            completionBlock ? completionBlock(granted, error) : nil;
        }];
    }
}

@end
