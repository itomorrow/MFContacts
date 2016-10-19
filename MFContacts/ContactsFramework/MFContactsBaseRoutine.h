//
//  MFContactsBaseRoutine.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface MFContactsBaseRoutine : NSObject

@property (nonatomic, readonly) CNContactStore *contactStore;

- (instancetype)initWithContactStore:(CNContactStore *)contactStore;

@end
