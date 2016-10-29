//
//  ASContactBuilder.h
//  AndroidShell
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "MFTypes.h"

@class MFContact;

@interface MFAddressBookUpdate : NSObject

- (void)updateContact:(MFContact*)contactSrc toContactRef:(ABRecordRef)contactDst;

@end
