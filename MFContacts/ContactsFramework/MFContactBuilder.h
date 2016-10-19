//
//  MFContactBuilder.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "MFTypes.h"

@class MFContact;

@interface MFContactBuilder : NSObject

@property (nonatomic, weak) CNContactStore *contactStore;

- (MFContact *)contactWithIdentifier:(NSString*)identifier fieldMask:(MFContactField)fieldMask;

- (CNMutableContact*)contactRefWithContact:(MFContact *)contact;

- (NSArray*)fetchKeysFromContactField:(MFContactField)fieldMask;

@end
