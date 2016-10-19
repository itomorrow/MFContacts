//
//  MFContactsStoreRoutine.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "MFContactsStoreRoutine.h"
#import "MFContactDataExtractor.h"
#import "MFContactBuilder.h"
#import "MFContactsModels.h"

@interface MFContactsStoreRoutine ()
@property (nonatomic, strong) MFContactBuilder *builder;
@end

@implementation MFContactsStoreRoutine

#pragma mark - life cycle

- (instancetype)initWithContactStore:(CNContactStore *)contactStore;
{
    self = [super initWithContactStore:contactStore];
    self.builder = [[MFContactBuilder alloc] init];
    self.builder.contactStore = contactStore;
    return self;
}

#pragma mark - public

- (void)allContactsWithContactFieldMask:(MFContactField)fieldMask with:(nonnull MFReadContactsBlock)block
{
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    if (self.contactStore)
    {
        NSArray* keys = @[CNContactIdentifierKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        NSError *error = nil;
        [self.contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            MFContact* con = [self.builder contactWithIdentifier:contact.identifier fieldMask:fieldMask];
            [contacts addObject:con];
        }];
        block(contacts, nil);
    }
}

- (MFContact *)contactByIdentifier:(NSString *)identifier withFieldMask:(MFContactField)fieldMask
{
    if (self.contactStore) {
        return [self.builder contactWithIdentifier:identifier fieldMask:fieldMask];
    }
    return nil;
}

- (UIImage *)imageWithIdentifier:(NSString *)identifier
{
    if (self.contactStore) {
        MFContact* contact = [self.builder contactWithIdentifier:identifier fieldMask:MFContactFieldThumbnail];
        return contact.thumbnail;
    }
    return nil;
}

- (nullable NSError*)writeContact:(nonnull MFContact *)contact{

    CNMutableContact* newContact = [self.builder contactRefWithContact:contact];
    
    CNSaveRequest* saveRequest = [[CNSaveRequest alloc] init];
    
    [saveRequest addContact:newContact toContainerWithIdentifier:nil];
    
    NSError* err = nil;
    BOOL result = [self.contactStore executeSaveRequest:saveRequest error:&err];
    if (result && err == nil) {
        NSLog(@"executeSaveRequest success");
        return err;
    } else {
        NSLog(@"executeSaveRequest failed, error = %@", err);
    }

    return err;
}

- (nullable NSError*)writeContacts:(nonnull NSArray *)contacts{
    
    CNSaveRequest* saveRequest = [[CNSaveRequest alloc] init];
    for (MFContact* con in contacts) {
        CNMutableContact* newContact = [self.builder contactRefWithContact:con];
        [saveRequest addContact:newContact toContainerWithIdentifier:nil];
    }
    
    NSError* err = nil;
    BOOL result = [self.contactStore executeSaveRequest:saveRequest error:&err];
    if (result && err == nil) {
        NSLog(@"executeSaveRequest success");
        return err;
    } else {
        NSLog(@"executeSaveRequest failed, error = %@", err);
    }
    
    return err;
}

// remove contact
- (nullable NSError*)removeContactByIdentifier:(nonnull NSString *)identifier{
    
    CNSaveRequest* saveRequest = [[CNSaveRequest alloc] init];
    CNContact* delContact = [self.contactStore unifiedContactWithIdentifier:identifier keysToFetch:[self.builder fetchKeysFromContactField:MFContactFieldIdentifier] error:nil];
    
    CNMutableContact* mutableDelContact = [delContact mutableCopy];
    [saveRequest deleteContact:mutableDelContact];
    
    NSError* err = nil;
    BOOL result = [self.contactStore executeSaveRequest:saveRequest error:&err];
    if (result && err == nil) {
        NSLog(@"executeSaveRequest success");
    } else {
        NSLog(@"executeSaveRequest failed, error = %@", err);
    }
    return err;
}

- (nullable NSError*)removeContactsByIdentifiers:(nonnull NSArray *)identifiers{

    NSError* err = nil;
    NSPredicate* idPredicate = [CNContact predicateForContactsWithIdentifiers:identifiers];
    NSArray* delContacts = [self.contactStore unifiedContactsMatchingPredicate:idPredicate keysToFetch:[self.builder fetchKeysFromContactField:MFContactFieldIdentifier] error:&err];
    
    if (delContacts && delContacts.count > 0 && !err) {
        CNSaveRequest* saveRequest = [[CNSaveRequest alloc] init];
        for (CNContact* del in delContacts) {
            CNMutableContact* mutable = [del mutableCopy];
            [saveRequest deleteContact:mutable];
        }
        
        BOOL result = [self.contactStore executeSaveRequest:saveRequest error:&err];
        if (result && err == nil) {
            NSLog(@"executeSaveRequest success");
        } else {
            NSLog(@"executeSaveRequest failed, error = %@", err);
        }
    }
    
    return nil;
}

@end
