//
//  MFContactBuilder.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFContactBuilder.h"
#import "MFContactDataExtractor.h"
#import "MFContactDataComposer.h"
#import "MFContactsHelper.h"
#import "MFContactsModels.h"

@interface MFContactBuilder ()
@property (nonatomic, strong) MFContactDataExtractor *extractor;
@property (nonatomic, strong) MFContactDataComposer *composer;
@end

@implementation MFContactBuilder

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    self.extractor = [[MFContactDataExtractor alloc] init];
    self.composer = [[MFContactDataComposer alloc] init];
    return self;
}

#pragma mark - public
- (MFContact *)contactWithIdentifier:(NSString*)identifier fieldMask:(MFContactField)fieldMask
{
    NSError* err = nil;
    CNContact* fetal = [self.contactStore unifiedContactWithIdentifier:identifier keysToFetch:[self fetchKeysFromContactField:fieldMask] error:&err];
    self.extractor.contactRef = fetal;
    
    MFContact *contact = [[MFContact alloc] init];
    contact.identifier = identifier;
    
    if (fieldMask & MFContactFieldName)
    {
        contact.name = [self.extractor name];
    }
    if (fieldMask & MFContactFieldJob)
    {
        contact.job = [self.extractor job];
    }
    if (fieldMask & MFContactFieldPhone)
    {
        contact.photo = [self.extractor photo];
    }
    if (fieldMask & MFContactFieldPhone)
    {
        contact.phones = [self.extractor phones];
    }
    if (fieldMask & MFContactFieldEmail)
    {
        contact.emails = [self.extractor emails];
    }
    if (fieldMask & MFContactFieldAddress)
    {
        contact.addresses = [self.extractor addresses];
    }
    if (fieldMask & MFContactFieldSocialProfiles)
    {
        contact.socialProfiles = [self.extractor socialProfiles];
    }
    if (fieldMask & MFContactFieldBirthday)
    {
        contact.birthday = [self.extractor birthday];
    }
    if (fieldMask & MFContactFieldNote)
    {
        contact.note = [self.extractor note];
    }
    if (fieldMask & MFContactFieldRelatedPersons)
    {
        contact.relatedPersons = [self.extractor relatedPersons];
    }
    if (fieldMask & MFContactFieldDates)
    {
        contact.dates = [self.extractor dates];
    }
    
    return contact;
}

- (CNMutableContact*)contactRefWithContact:(MFContact *)contact
{
    CNMutableContact* contactRef = [[CNMutableContact alloc] init];
    self.composer.contactRef = contactRef;
    
    if (contact.name) {
        [self.composer composeName:contact.name];
    }
    if (contact.job) {
        [self.composer composeJob:contact.job];
    }
    if (contact.photo) {
        [self.composer composePhoto:contact.photo];
    }
    if (contact.phones.count > 0) {
        [self.composer composePhones:contact.phones];
    }
    if (contact.emails.count > 0) {
        [self.composer composeEmails:contact.emails];
    }
    if (contact.addresses.count > 0) {
        [self.composer composeAddresses:contact.addresses];
    }
    if (contact.socialProfiles.count > 0) {
        [self.composer composeSocialProfiles:contact.socialProfiles];
    }
    if (contact.birthday) {
        [self.composer composeBirthday:contact.birthday];
    }
    if (contact.note) {
        [self.composer composeNote:contact.note];
    }
    if (contact.relatedPersons) {
        [self.composer composeRelatedPersons:contact.relatedPersons];
    }
    if (contact.dates) {
        [self.composer composeDates:contact.dates];
    }

    return contactRef;
}

- (NSArray*)fetchKeysFromContactField:(MFContactField)fieldMask{
    NSMutableArray* fieldKeys = [[NSMutableArray alloc] init];
    
    if (fieldMask & MFContactFieldName)
    {
        [fieldKeys addObject:[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]];
    }
    if (fieldMask & MFContactFieldJob)
    {
        [fieldKeys addObject:CNContactDepartmentNameKey];
        [fieldKeys addObject:CNContactJobTitleKey];
    }
    if (fieldMask & MFContactFieldPhoto)
    {
        [fieldKeys addObject:CNContactThumbnailImageDataKey];
    }
    if (fieldMask & MFContactFieldPhone)
    {
        [fieldKeys addObject:CNContactPhoneNumbersKey];
    }
    if (fieldMask & MFContactFieldEmail)
    {
        [fieldKeys addObject:CNContactEmailAddressesKey];
    }
    if (fieldMask & MFContactFieldAddress)
    {
        [fieldKeys addObject:CNContactPostalAddressesKey];
    }
    if (fieldMask & MFContactFieldSocialProfiles)
    {
        [fieldKeys addObject:CNContactSocialProfilesKey];
    }
    if (fieldMask & MFContactFieldBirthday)
    {
        [fieldKeys addObject:CNContactBirthdayKey];
    }
    if (fieldMask & MFContactFieldNote)
    {
        [fieldKeys addObject:CNContactNoteKey];
    }
    if (fieldMask & MFContactFieldRelatedPersons)
    {
        [fieldKeys addObject:CNContactRelationsKey];
    }
    if (fieldMask & MFContactFieldDates)
    {
        [fieldKeys addObject:CNContactDatesKey];
    }
    if (fieldMask & MFContactFieldIdentifier)
    {
        [fieldKeys addObject:CNContactIdentifierKey];
    }
    return fieldKeys;
}

@end
