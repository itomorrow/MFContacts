//
//  ASAddressBookBuilder.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/ABRecord.h>
#import "MFTypes.h"

@class MFContact;

@interface MFAddressBookBuilder : NSObject

- (MFContact *)contactWithRecordRef:(ABRecordRef)recordRef fieldMask:(MFContactField)fieldMask;

- (ABRecordRef)recordRefWithContact:(MFContact *)contact;

@end
