//
//  MFContactsStoreRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFContactsBaseRoutine.h"
#import "MFTypes.h"
#import "MFContactsModels.h"

typedef void(^MFReadContactsBlock)(NSArray <MFContact *> * _Nullable contacts, NSError * _Nullable error);

@interface MFContactsStoreRoutine : MFContactsBaseRoutine

//read
- (void)allContactsWithContactFieldMask:(MFContactField)fieldMask with:(nonnull MFReadContactsBlock)block;
- (nullable MFContact *)contactByIdentifier:(nullable NSString *)identifier withFieldMask:(MFContactField)fieldMask;
- (nullable UIImage *)imageWithIdentifier:(nullable NSString *)identifier;

// write contact
- (nullable NSError*)writeContact:(nonnull MFContact *)contact;
- (nullable NSError*)writeContacts:(nonnull NSArray *)contacts;

// remove contact
- (nullable NSError*)removeContactByIdentifier:(nonnull NSString *)identifier;
- (nullable NSError*)removeContactsByIdentifiers:(nonnull NSArray *)identifiers;

@end
