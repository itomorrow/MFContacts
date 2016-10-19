//
//  ASAddressBookBuilder.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookBuilder.h"
#import "MFAddressBookDataExtractor.h"
#import "MFAddressBookDataComposer.h"
#import "MFContactsHelper.h"
#import "MFContactsModels.h"

@interface MFAddressBookBuilder ()
@property (nonatomic, strong) MFAddressBookDataExtractor *extractor;
@property (nonatomic, strong) MFAddressBookDataComposer *composer;
@end

@implementation MFAddressBookBuilder

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    self.extractor = [[MFAddressBookDataExtractor alloc] init];
    self.composer = [[MFAddressBookDataComposer alloc] init];
    return self;
}

#pragma mark - public

- (MFContact *)contactWithRecordRef:(ABRecordRef)recordRef fieldMask:(MFContactField)fieldMask
{
    self.extractor.recordRef = recordRef;
    MFContact *contact = [[MFContact alloc] init];
    
    NSNumber* recordID =@(ABRecordGetRecordID(recordRef));
    contact.identifier = recordID.stringValue;
    
    if (fieldMask & MFContactFieldName)
    {
        contact.name = [self.extractor name];
    }
    if (fieldMask & MFContactFieldJob)
    {
        contact.job = [self.extractor job];
    }
    if (fieldMask & MFContactFieldThumbnail)
    {
        contact.thumbnail = [self.extractor thumbnail];
    }
    if (fieldMask & MFContactFieldPhonesOnly || fieldMask & MFContactFieldPhonesWithLabels)
    {
        contact.phones = [self.extractor phonesWithLabels:(fieldMask & MFContactFieldPhonesWithLabels)];
    }
    if (fieldMask & MFContactFieldEmailsOnly || fieldMask & MFContactFieldEmailsWithLabels)
    {
        contact.emails = [self.extractor emailsWithLabels:(fieldMask & MFContactFieldEmailsWithLabels)];
    }
    if (fieldMask & MFContactFieldAddressesOnly || fieldMask & MFContactFieldAddressesWithLabels)
    {
        contact.addresses = [self.extractor addressesWithLabels:(fieldMask & MFContactFieldAddressesWithLabels)];
    }
    if (fieldMask & MFContactFieldSocialProfiles)
    {
        contact.socialProfiles = [self.extractor socialProfiles];
    }
    if (fieldMask & MFContactFieldBirthday)
    {
        contact.birthday = [self.extractor dateProperty:kABPersonBirthdayProperty];
    }
    if (fieldMask & MFContactFieldNote)
    {
        contact.note = [self.extractor stringProperty:kABPersonNoteProperty];
    }
    if (fieldMask & MFContactFieldRelatedPersons)
    {
        contact.relatedPersons = [self.extractor relatedPersons];
    }
    if (fieldMask & MFContactFieldLinkedRecordIDs)
    {
        contact.linkedRecordIDs = [self.extractor linkedRecordIDs];
    }
    if (fieldMask & MFContactFieldSource)
    {
        contact.source = [self.extractor source];
    }
    if (fieldMask & MFContactFieldDates)
    {
        contact.dates = [self.extractor dates];
    }
    if (fieldMask & MFContactFieldRecordDate)
    {
        contact.recordDate = [self.extractor recordDate];
    }
    return contact;
}

- (ABRecordRef)recordRefWithContact:(MFContact *)contact{
    
    ABRecordRef record = ABPersonCreate();
    self.composer.recordRef = record;
    
    if (contact.name) {
        [self.composer composeName:contact.name];
    }
    if (contact.job) {
        [self.composer composeJob:contact.job];
    }
    if (contact.thumbnail) {
        [self.composer composeThumbnail:contact.thumbnail];
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
        [self.composer setDateProperty:kABPersonBirthdayProperty withValue:contact.birthday];
    }
    if (contact.note) {
        [self.composer setStringProperty:kABPersonNoteProperty withValue:contact.note];
    }
    if (contact.relatedPersons) {
        [self.composer composeRelatedPersons:contact.relatedPersons];
    }
    if (contact.linkedRecordIDs) {
        [self.composer composeLinkedRecordIDs:contact.linkedRecordIDs];
    }
    if (contact.source) {
        [self.composer composeSource:contact.source];
    }
    if (contact.dates) {
        [self.composer composeDates:contact.dates];
    }
    if (contact.recordDate) {
        [self.composer composeRecordDate:contact.recordDate];
    }
    return record;
}

@end
