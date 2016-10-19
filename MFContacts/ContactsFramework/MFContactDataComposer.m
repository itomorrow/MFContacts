//
//  MFContactDataComposer.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import "MFContactDataComposer.h"
#import "MFContactsModels.h"


@implementation MFContactDataComposer

#pragma mark - public

- (void)composeName:(MFName*)name{
    
    if (name.firstName.length > 0) {
        self.contactRef.givenName = name.firstName;
    }
    if (name.lastName.length > 0) {
        self.contactRef.familyName = name.lastName;
    }
}

- (void)composeJob:(MFJob*)job{
    if (job.orgnazition.length > 0) {
        self.contactRef.organizationName = job.orgnazition;
    }
    if (job.department.length > 0) {
        self.contactRef.departmentName = job.department;
    }
    if (job.jobTitle.length > 0) {
        self.contactRef.jobTitle = job.jobTitle;
    }
}

- (void)composePhones:(NSArray*)phones{
    NSMutableArray* targetPhones = [[NSMutableArray alloc] init];
    for (MFPhone* phone in phones) {
        CNPhoneNumber* numberValue = [CNPhoneNumber phoneNumberWithStringValue:phone.number];
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:phone.originalLabel value:numberValue];
        [targetPhones addObject:labeledValue];
    }
    self.contactRef.phoneNumbers = targetPhones;
}

- (void)composeEmails:(NSArray*)emails{
    NSMutableArray* targetEmails = [[NSMutableArray alloc] init];
    for (MFEmail* mail in emails) {
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:mail.originalLabel value:mail.address];
        [targetEmails addObject:labeledValue];
    }
    self.contactRef.emailAddresses = targetEmails;
}

- (void)composeAddresses:(NSArray*)addresses{
    NSMutableArray* targetAddresses = [[NSMutableArray alloc] init];
    for (MFAddress* address in addresses) {
        CNMutablePostalAddress* addressObj = [[CNMutablePostalAddress alloc] init];
        addressObj.city = address.city;
        addressObj.street = address.street;
        addressObj.state = address.state;
        addressObj.country = address.country;
        addressObj.ISOCountryCode = address.countryCode;
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:address.originalLabel value:addressObj];
        [targetAddresses addObject:labeledValue];
    }
    self.contactRef.postalAddresses = targetAddresses;
}

- (void)composeSocialProfiles:(NSArray*)profiles{
    NSMutableArray* targetSocials = [[NSMutableArray alloc] init];
    for (MFSocialProfile* social in profiles) {
        CNSocialProfile* socialObj = [[CNSocialProfile alloc] initWithUrlString:
                                      [social.url absoluteString]
                                                                       username:social.username userIdentifier:social.userIdentifier
                                                                        service:[self socialNetworkTypeWithType:social.socialNetwork]];
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:socialObj];
        [targetSocials addObject:labeledValue];
    }
    self.contactRef.socialProfiles = targetSocials;

}

- (void)composeRelatedPersons:(NSArray*)persons{
    NSMutableArray* targetPersons = [[NSMutableArray alloc] init];
    for (MFRelatedPerson* person in persons) {
        CNContactRelation* relation = [[CNContactRelation alloc] initWithName:person.name];
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:person.originalLabel value:relation];
        [targetPersons addObject:labeledValue];
    }
    self.contactRef.contactRelations = targetPersons;
}

- (void)composeDates:(NSArray*)dates{
    
    NSMutableArray* targetDates = [[NSMutableArray alloc] init];
    for (MFContactDate* date in dates) {
        NSDateComponents* com = [[NSDateComponents alloc] init];
        com.year = 1998;
        com.month = 3;
        com.day = 22;
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:date.originalLabel value:com];
        [targetDates addObject:labeledValue];
    }
    self.contactRef.dates = targetDates;
}

- (void)composeBirthday:(NSDate*)date{
    NSDateComponents* com = [[NSDateComponents alloc] init];
    com.year = 1998;
    com.month = 3;
    com.day = 22;
    self.contactRef.birthday = com;
}

- (void)composeNote:(NSString*)note{
    self.contactRef.note = note;
}

- (void)composeWebsites:(NSArray*)urls{
    NSMutableArray* targetURLs = [[NSMutableArray alloc] init];
    for (NSString* url in urls) {
        CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:url];
        [targetURLs addObject:labeledValue];
    }
    self.contactRef.urlAddresses = targetURLs;
}

- (void)composeThumbnail:(UIImage *)image{
    self.contactRef.imageData = UIImagePNGRepresentation(image);
}

#pragma mark - private
- (NSString*)socialNetworkTypeWithType:(MFSocialNetworkType)type{

    NSString* result = nil;
    if (type == MFSocialNetworkFacebook) {
        result = CNSocialProfileServiceFacebook;
    }
    if (type == MFSocialNetworkFlickr) {
        result = CNSocialProfileServiceFlickr;
    }
    if (type == MFSocialNetworkTwitter) {
        result = CNSocialProfileServiceTwitter;
    }
    if (type == MFSocialNetworkLinkedIn) {
        result = CNSocialProfileServiceLinkedIn;
    }
    if (type == MFSocialNetworkGameCenter) {
        result = CNSocialProfileServiceGameCenter;
    }
    if (type == MFSocialNetworkMySpace) {
        result = CNSocialProfileServiceMySpace;
    }
    if (type == MFSocialNetworkYelp) {
        result = CNSocialProfileServiceYelp;
    }
    if (type == MFSocialNetworkSinaWeibo) {
        result = CNSocialProfileServiceSinaWeibo;
    }
    if (type == MFSocialNetworkTencentWeibo) {
        result = CNSocialProfileServiceTencentWeibo;
    }
    return result;
}


@end
