//
//  ASAddressBookContactsRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFAddressBookBaseRoutine.h"
#import "MFTypes.h"

@class MFContact;

@interface MFAddressBookContactsRoutine : MFAddressBookBaseRoutine

// read
- (nullable NSArray *)allContactsWithContactFieldMask:(MFContactField)fieldMask;
- (nullable MFContact *)contactByIdentifier:(nullable NSString *)identifier withFieldMMFk:(MFContactField)fieldMask;
- (nullable NSData *)imageWithIdentifier:(nullable NSString *)identifier;

// write contact
- (nullable NSError*)writeContact:(nonnull MFContact *)contact;
- (nullable NSError*)writeContacts:(nonnull NSArray *)contacts;

// update contact
- (BOOL)updateContact:(nonnull MFContact *)contact;
- (BOOL)updateContacts:(nonnull NSArray *)contacts;

// remove contact
- (nullable NSError*)removeContactByIdentifier:(nonnull NSString *)identifier;
- (nullable NSError*)removeContactsByIdentifiers:(nonnull NSArray *)identifiers;

@end
