//
//  MFAddressBookContactsRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "MFAddressBookContactsRoutine.h"
#import "MFAddressBookDataExtractor.h"
#import "MFAddressBookBuilder.h"
#import "MFContactsModels.h"
#import "MFAddressBookUpdate.h"

@interface MFAddressBookContactsRoutine ()
@property (nonatomic, strong) MFAddressBookBuilder *builder;
@property (nonatomic, strong) MFAddressBookUpdate *update;
@end

@implementation MFAddressBookContactsRoutine

#pragma mark - life cycle

- (instancetype)initWithAddressBookRefWrapper:(MFAddressBookRefWrapper *)wrapper
{
    self = [super initWithAddressBookRefWrapper:wrapper];
    self.builder = [[MFAddressBookBuilder alloc] init];
    self.update = [[MFAddressBookUpdate alloc] init];
    return self;
}

#pragma mark - public

- (NSArray *)allContactsWithContactFieldMask:(MFContactField)fieldMask
{
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    if (self.wrapper.ref)
    {
        CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(self.wrapper.ref);
        CFIndex count = CFArrayGetCount(peopleArrayRef);
        for (CFIndex i = 0; i < count; i++)
        {
            ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleArrayRef, i);
            MFContact *contact = [self.builder contactWithRecordRef:recordRef fieldMask:fieldMask];
            [contacts addObject:contact];
        }
        CFRelease(peopleArrayRef);
    }
    return contacts.count > 0 ? contacts.copy : nil;
}

- (MFContact *)contactByIdentifier:(NSString *)identifier withFieldMMFk:(MFContactField)fieldMask
{
    if (self.wrapper.ref)
    {
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, identifier.intValue);
        return recordRef != NULL ? [self.builder contactWithRecordRef:recordRef fieldMask:fieldMask] : nil;
    }
    return nil;
}

- (NSData *)imageWithIdentifier:(NSString *)identifier
{
    if (self.wrapper.ref)
    {
        ABRecordID recordID = identifier.intValue;
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, recordID);
        MFContact* contact = [self.builder contactWithRecordRef:recordRef fieldMask:MFContactFieldPhoto];
        return contact.imageData;
    }
    return nil;
}

- (nullable NSError*)writeContact:(nonnull MFContact *)contact{

    ABRecordRef record = [self.builder recordRefWithContact:contact];
    
    CFErrorRef err = NULL;
    bool didset = ABAddressBookAddRecord(self.wrapper.ref, record, &err);
    if (!didset || err != nil) {
        NSLog(@"ABAddressBookAddRecord failed, error = %@", err);
        return (__bridge NSError*)err;
    }
    
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref))
    {
        didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"ABAddressBookSave success");
        } else {
            NSLog(@"ABAddressBookAddRecord failed, error = %@", err);
        }
    }
    CFRelease(record);
    
    return (__bridge NSError*)err;
}

- (nullable NSError*)writeContacts:(nonnull NSArray *)contacts{
    
    for (MFContact* contact in contacts) {
        ABRecordRef ref = [self.builder recordRefWithContact:contact];
        CFErrorRef err = NULL;
        bool didset = ABAddressBookAddRecord(self.wrapper.ref, ref, &err);
        if (!didset || err != nil) {
            NSLog(@"ABAddressBookAddRecord failed, error = %@", err);
            return (__bridge NSError*)err;
        }
    }
    
    CFErrorRef err = NULL;
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref)){
        bool didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"ABAddressBookSave success");
        } else {
            NSLog(@"ABAddressBookSave failed, error = %@", err);
        }
    }
    
    return (__bridge NSError*)err;
}

- (BOOL)updateContact:(nonnull MFContact *)contact{
    
    ABRecordID recordID = contact.identifier.intValue;
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, recordID);
#warning identifier
    
    [self.update updateContact:contact toContactRef:recordRef];
    
    CFErrorRef err = NULL;
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref))
    {
        bool didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"added!");
        } else {
            NSLog(@"added failed!");
        }
    }
    CFRelease(recordRef);
    
    return YES;
}

- (BOOL)updateContacts:(nonnull NSArray *)contacts{
    
    for (MFContact* contact in contacts) {
        ABRecordID recordID = contact.identifier.intValue;
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, recordID);
#warning identifier
        
        [self.update updateContact:contact toContactRef:recordRef];
        CFRelease(recordRef);
    }
    
    CFErrorRef err = NULL;
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref))
    {
        bool didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"added!");
        } else {
            NSLog(@"added failed!");
        }
    }
    
    return YES;
}

// remove contact
- (nullable NSError*)removeContactByIdentifier:(nonnull NSString *)identifier{
    
    CFErrorRef err = NULL;
    
    bool didset;
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, identifier.intValue);
    didset = ABAddressBookRemoveRecord(self.wrapper.ref, recordRef, &err);
    if (didset && err == NULL) {
        NSLog(@"ABAddressBookRemoveRecord success");
    } else {
        NSLog(@"ABAddressBookRemoveRecord failed, error = %@", err);
        return (__bridge NSError*)err;
    }
    
    
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref))
    {
        didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"ABAddressBookSave success");
        } else {
            NSLog(@"ABAddressBookSave failed, error = %@", err);
        }
    }
    
    return (__bridge NSError*)err;
}

- (nullable NSError*)removeContactsByIdentifiers:(nonnull NSArray *)identifiers{
    
    CFErrorRef err = NULL;
    bool didset;
    for (NSString* identifier in identifiers) {
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.wrapper.ref, identifier.intValue);
        
        didset = ABAddressBookRemoveRecord(self.wrapper.ref, recordRef, &err);
        if (didset && err == NULL) {
            NSLog(@"ABAddressBookRemoveRecord success");
        } else {
            NSLog(@"ABAddressBookRemoveRecord failed, error = %@", err);
            return (__bridge NSError*)err;
        }
    }
    
    if (ABAddressBookHasUnsavedChanges(self.wrapper.ref))
    {
        didset = ABAddressBookSave(self.wrapper.ref, &err);
        if (didset && err == NULL) {
            NSLog(@"ABAddressBookRemoveRecord success");
        } else {
            NSLog(@"ABAddressBookRemoveRecord failed, error = %@", err);
        }
    }
    
    return (__bridge NSError*)err;
}

@end
