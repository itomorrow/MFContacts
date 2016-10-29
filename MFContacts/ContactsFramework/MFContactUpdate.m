//
//  ASContactBuilder.m
//  AndroidShell
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFContactUpdate.h"
#import "MFContactDataExtractor.h"
#import "MFContactDataComposer.h"
#import "MFContactsHelper.h"
#import "MFContactsModels.h"

@interface MFContactUpdate ()
@property (nonatomic, weak) MFContact *contactSrc;
@property (nonatomic, weak) CNMutableContact *contactDst;
@end

@implementation MFContactUpdate

#pragma mark - public
- (void)updateContact:(MFContact*)contactSrc toContactRef:(CNMutableContact*)contactDst{

    self.contactDst = contactDst;
    self.contactSrc = contactSrc;
    
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
}

#pragma mark - private func
- (void)updateName{
    if (!self.contactDst.givenName || self.contactDst.givenName.length == 0) {
        self.contactDst.givenName = self.contactSrc.name.firstName;
    }
    if (!self.contactDst.familyName || self.contactDst.familyName.length == 0) {
        self.contactDst.familyName = self.contactSrc.name.lastName;
    }
    if (!self.contactDst.middleName || self.contactDst.middleName.length == 0) {
        self.contactDst.middleName = self.contactSrc.name.middleName;
    }
}

- (void)updateJob{
    if (!self.contactDst.organizationName || self.contactDst.organizationName.length == 0) {
        self.contactDst.organizationName = self.contactSrc.job.orgnazition;
    }
    if (!self.contactDst.departmentName || self.contactDst.departmentName.length == 0) {
        self.contactDst.departmentName = self.contactSrc.job.department;
    }
    if (!self.contactDst.jobTitle || self.contactDst.jobTitle.length == 0) {
        self.contactDst.jobTitle = self.contactSrc.job.jobTitle;
    }
}

- (void)updateThumbnil{
    if (!self.contactDst.imageData) {
        self.contactDst.imageData = self.contactSrc.imageData;
    }
}

- (void)updatePhones{
    NSMutableArray* newNumbers = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.phones.count];
    for (MFPhone* phone in self.contactSrc.phones) {
        BOOL bFind = NO;
        for (CNLabeledValue* phoneLabel in self.contactDst.phoneNumbers) {
            NSString* number = phoneLabel.value;
            if ([phone.number isEqualToString:number]) {
                bFind = YES;
                break;
            }
        }
        
        if (bFind == NO) {
            [newNumbers addObject:phone];
        }
    }
    
    if (newNumbers.count > 0) {
        NSMutableArray* targetPhones = [NSMutableArray arrayWithArray:self.contactDst.phoneNumbers];
        for (MFPhone* phone in newNumbers) {
            CNPhoneNumber* numberValue = [CNPhoneNumber phoneNumberWithStringValue:phone.number];
            CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:phone.originalLabel value:numberValue];
            [targetPhones addObject:labeledValue];
        }
        self.contactDst.phoneNumbers = targetPhones;
    }
}

- (void)updateEmails{
    NSMutableArray* newEmails = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.emails.count];
    for (MFEmail* mail in self.contactSrc.emails) {
        BOOL bFind = NO;
        for (CNLabeledValue* mailLabel in self.contactDst.emailAddresses) {
            NSString* dstMail = mailLabel.value;
            if ([mail.address isEqualToString:dstMail]) {
                bFind = YES;
                break;
            }
        }
        
        if (bFind == NO) {
            [newEmails addObject:mail];
        }
    }
    
    if (newEmails.count > 0) {
        NSMutableArray* targetEmails = [NSMutableArray arrayWithArray:self.contactDst.emailAddresses];
        for (MFEmail* mail in newEmails) {
            CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:mail.originalLabel value:mail.address];
            [targetEmails addObject:labeledValue];
        }
        self.contactDst.emailAddresses = targetEmails;
    }
}

- (void)updateAddresses{
    NSMutableArray* newAddresses = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.addresses.count];
    for (MFAddress* address in self.contactSrc.addresses) {
        BOOL bDiff = NO;
        for (CNLabeledValue* addressLabel in self.contactDst.postalAddresses) {
            CNPostalAddress* postAddress = addressLabel.value;
            
            if (![address.country isEqualToString:postAddress.country]) {
                bDiff = YES;
                break;
            }
            if (![address.city isEqualToString:postAddress.city]) {
                bDiff = YES;
                break;
            }
            if (![address.state isEqualToString:postAddress.state]) {
                bDiff = YES;
                break;
            }
            if (![address.street isEqualToString:postAddress.street]) {
                bDiff = YES;
                break;
            }
            if (![address.zip isEqualToString:postAddress.postalCode]) {
                bDiff = YES;
                break;
            }
        }
        
        if (bDiff == YES) {
            [newAddresses addObject:address];
        }
    }
    
    if (newAddresses.count > 0) {
        NSMutableArray* targetAddresses = [NSMutableArray arrayWithArray:self.contactDst.postalAddresses];
        for (MFAddress* address in newAddresses) {
            CNMutablePostalAddress* addressObj = [[CNMutablePostalAddress alloc] init];
            addressObj.city = address.city;
            addressObj.street = address.street;
            addressObj.state = address.state;
            addressObj.country = address.country;
            addressObj.ISOCountryCode = address.countryCode;
            CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:address.originalLabel value:addressObj];
            [targetAddresses addObject:labeledValue];
        }
        self.contactDst.postalAddresses = targetAddresses;
    }
    
    
    
}

- (void)updateNote{
    if (!self.contactDst.note || self.contactDst.note.length == 0) {
        self.contactDst.note = self.contactSrc.note;
    }
}

- (void)updateWebsites{
    NSMutableArray* newWebsites = [[NSMutableArray alloc] initWithCapacity:self.contactSrc.websites.count];
    for (MFWebSite* website in self.contactSrc.websites) {
        BOOL bFind = NO;
        for (CNLabeledValue* webLabel in self.contactDst.urlAddresses) {
            NSString* dstWebsite = webLabel.value;
            if ([website.website isEqualToString:dstWebsite]) {
                bFind = YES;
                break;
            }
        }
        
        if (bFind == NO) {
            [newWebsites addObject:website];
        }
    }
    
    if (newWebsites.count > 0) {
        NSMutableArray* targetWebsites = [NSMutableArray arrayWithArray:self.contactDst.emailAddresses];
        for (MFWebSite* url in newWebsites) {
            CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:url.originalLabel value:url.website];
            [targetWebsites addObject:labeledValue];
        }
        self.contactDst.urlAddresses = targetWebsites;
    }
}

@end
