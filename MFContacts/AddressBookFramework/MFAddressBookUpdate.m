//
//  ASContactBuilder.m
//  AndroidShell
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookUpdate.h"
#import "MFContactsModels.h"
#import "MFAddressBookDataExtractor.h"
#import "MFAddressBookDataComposer.h"

@interface MFAddressBookUpdate ()
@property (nonatomic, weak) MFContact *contactSrc;
@property (nonatomic, assign) ABRecordRef contactDst;
@property (nonnull, strong) MFAddressBookDataExtractor* extractor;
@property (nonnull, strong) MFAddressBookDataComposer* composer;
@end

@implementation MFAddressBookUpdate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _extractor = [[MFAddressBookDataExtractor alloc] init];
        _composer = [[MFAddressBookDataComposer alloc] init];
    }
    return self;
}

#pragma mark - public
- (void)updateContact:(MFContact*)contactSrc toContactRef:(ABRecordRef)contactDst{

    self.contactDst = contactDst;
    self.contactSrc = contactSrc;
    self.extractor.recordRef = contactDst;
    self.composer.recordRef = contactDst;
    
    // name
    [self updateName];
    
    // job
    [self updateJob];
    
    // thumbnil
    [self updateThumbnil];
    
    // phones
    [self updatePhones];

    // Emails
    [self updateEmails];
    
    // Addresses
    [self updateAddresses];
    
    // note
    [self updateNote];
    
    // websites
    [self updateWebsites];
    
    self.contactSrc = nil;
    self.contactDst = nil;
    self.extractor.recordRef = nil;
    self.composer.recordRef = nil;
}

#pragma mark - private func
- (void)updateName{
    
    MFName* dstName = [self.extractor name];
    if (!dstName.firstName || dstName.firstName.length == 0) {
        dstName.firstName = self.contactSrc.name.firstName;
    }
    if (!dstName.lastName || dstName.lastName.length == 0) {
        dstName.lastName = self.contactSrc.name.lastName;
    }
    if (!dstName.middleName || dstName.middleName.length == 0) {
        dstName.middleName = self.contactSrc.name.middleName;
    }
    [self.composer composeName:dstName];
}

- (void)updateJob{
    MFJob* dstJob = [self.extractor job];
    if (!dstJob.orgnazition || dstJob.orgnazition.length == 0) {
        dstJob.orgnazition = self.contactSrc.job.orgnazition;
    }
    if (!dstJob.department || dstJob.department.length == 0) {
        dstJob.department = self.contactSrc.job.department;
    }
    if (!dstJob.jobTitle || dstJob.jobTitle.length == 0) {
        dstJob.jobTitle = self.contactSrc.job.jobTitle;
    }
    [self.composer composeJob:dstJob];
}

- (void)updateThumbnil{
    NSData* img = [self.extractor photo];
    if (!img) {
        [self.composer composePhoto:self.contactSrc.imageData];
    }
}

- (void)updatePhones{
    
    NSArray* localNumbers = [self.extractor phones];
    NSMutableArray* newNumbers = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.phones.count];
    for (MFPhone* phone in self.contactSrc.phones) {
        BOOL bFind = NO;
        for (MFPhone* localPhone in localNumbers) {
            if ([localPhone.number isEqualToString:phone.number]) {
                bFind = YES;
                break;
            }
        }
        
        if (bFind == NO) {
            [newNumbers addObject:phone];
        }
    }

    if (newNumbers.count > 0) {
        NSMutableArray* targetPhones = [NSMutableArray arrayWithArray:localNumbers];
        [targetPhones addObjectsFromArray:newNumbers];
        [self.composer composePhones:targetPhones];
    }
}

- (void)updateEmails{
    NSArray* localEmails = [self.extractor emails];
    NSMutableArray* newEmails = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.emails.count];
    for (MFEmail* mail in self.contactSrc.emails) {
        BOOL bFind = NO;
        for (MFEmail* localEmail in localEmails) {
            if ([localEmail.address isEqualToString:mail.address]) {
                bFind = YES;
                break;
            }
        }
        
        if (bFind == NO) {
            [newEmails addObject:mail];
        }
    }
    
    if (newEmails.count > 0) {
        NSMutableArray* targetEmails = [NSMutableArray arrayWithArray:localEmails];
        [targetEmails addObjectsFromArray:newEmails];
        [self.composer composeEmails:targetEmails];
    }
}

- (void)updateAddresses{
    NSArray* localAddresses = [self.extractor addresses];
    NSMutableArray* newAddresses = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.addresses.count];
    for (MFAddress* address in self.contactSrc.addresses) {
        BOOL bDiff = NO;
        for (MFAddress* localAddress in localAddresses) {
            if (![address.country isEqualToString:localAddress.country]) {
                bDiff = YES;
                break;
            }
            if (![address.city isEqualToString:localAddress.city]) {
                bDiff = YES;
                break;
            }
            if (![address.state isEqualToString:localAddress.state]) {
                bDiff = YES;
                break;
            }
            if (![address.street isEqualToString:localAddress.street]) {
                bDiff = YES;
                break;
            }
            if (![address.zip isEqualToString:localAddress.zip]) {
                bDiff = YES;
                break;
            }
        }
        
        if (bDiff) {
            [newAddresses addObject:address];
        }
    }
    
    if (newAddresses.count > 0) {
        NSMutableArray* targetAddresses = [NSMutableArray arrayWithArray:localAddresses];
        [targetAddresses addObjectsFromArray:newAddresses];
        [self.composer composeAddresses:targetAddresses];
    }
}

- (void)updateNote{
    NSString* note = [self.extractor stringProperty:kABPersonNoteProperty];
    if (!note || note.length == 0) {
        [self.composer setStringProperty:kABPersonNoteProperty withValue:self.contactSrc.note];
    }
}

- (void)updateWebsites{
//    NSMutableArray* newWebsites = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.websites.count];
//    for (ASWebSite* website in self.contactSrc.websites) {
//        BOOL bFind = NO;
//        for (CNLabeledValue* webLabel in self.contactDst.urlAddresses) {
//            NSString* dstWebsite = webLabel.value;
//            if ([website.website isEqualToString:dstWebsite]) {
//                bFind = YES;
//                break;
//            }
//        }
//        
//        if (bFind == NO) {
//            [newWebsites addObject:website];
//        }
//    }
//    
//    if (newWebsites.count > 0) {
//        NSMutableArray* targetWebsites = [NSMutableArray arrayWithArray:self.contactDst.emailAddresses];
//        for (ASWebSite* url in newWebsites) {
//            CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:url.originalLabel value:url.website];
//            [targetWebsites addObject:labeledValue];
//        }
//        self.contactDst.urlAddresses = targetWebsites;
//    }
}

@end
