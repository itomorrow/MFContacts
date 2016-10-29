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
    if (fieldMask & MFContactFieldPhoto)
    {
        contact.imageData = [self.extractor photo];
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
    if (fieldMask & MFContactFieldWebSite) {
        contact.websites = [self.extractor websites];
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
    if (contact.imageData) {
        [self.composer composePhoto:contact.imageData];
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
    if (contact.websites.count > 0) {
        [self.composer composeWebsites:contact.websites];
    }
    return record;
}

@end
