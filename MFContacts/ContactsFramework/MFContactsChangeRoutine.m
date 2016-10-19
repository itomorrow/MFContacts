//
//  MFContactsChangeRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFContactsChangeRoutine.h"


@implementation MFContactsChangeRoutine

#pragma mark - life cycle

- (instancetype)initWithContactStore:(CNContactStore *)contactStore
{
    self = [super initWithContactStore:contactStore];
    if (self)
    {
        [self registerExternalChangeCallback];
    }
    return self;
}

- (void)dealloc
{
    if (!self.contactStore)
    {
        [self unregisterExternalChangeCallback];
    }
}

#pragma mark - private

- (void)registerExternalChangeCallback
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeCallback:) name:CNContactStoreDidChangeNotification object:nil];
}

- (void)unregisterExternalChangeCallback
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

#pragma mark - external change callback
- (void)onChangeCallback:(NSNotification*)notification{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactsDidChange)]) {
        [self.delegate contactsDidChange];
    }
}

@end
