//
//  MFContactDataExtractor.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import "MFContactDataExtractor.h"
#import "MFContactsModels.h"
#import <Contacts/CNContactFormatter.h>
#import <Contacts/CNSocialProfile.h>


@implementation MFContactDataExtractor

#pragma mark - public
- (nullable MFName *)name
{
    MFName *name = [[MFName alloc] init];
    
    name.firstName = self.contactRef.givenName;
    name.lastName = self.contactRef.familyName;
    name.compositeName = [CNContactFormatter stringFromContact:self.contactRef style:CNContactFormatterStyleFullName];
    return name;
}

- (MFJob *)job
{
    MFJob *job = [[MFJob alloc] init];
    job.orgnazition = self.contactRef.organizationName;
    job.department = self.contactRef.departmentName;
    job.jobTitle = self.contactRef.jobTitle;
    return job;
}

- (NSArray *)phones
{
    return [self mapMultiValueOfProperty:self.contactRef.phoneNumbers withBlock:^id(CNLabeledValue *value) {
        CNPhoneNumber* number = value.value;
        MFPhone* phone = [[MFPhone alloc] init];
        phone.number = number.stringValue;
        phone.originalLabel = value.label;
        phone.localizedLabel = [self localizedLabelFromOriginalValue:value.label];
        return phone;
    }];
}

- (NSArray *)emails
{
    return [self mapMultiValueOfProperty:self.contactRef.emailAddresses withBlock:^id(CNLabeledValue *value) {
        MFEmail* mail = [[MFEmail alloc] init];
        mail.address = value.value;
        mail.originalLabel = value.label;
        mail.localizedLabel = [self localizedLabelFromOriginalValue:value.label];
        return mail;
    }];
}

- (NSArray *)addresses
{
    return [self mapMultiValueOfProperty:self.contactRef.postalAddresses withBlock:^id(CNLabeledValue *value) {
        MFAddress* address = [[MFAddress alloc] init];
        CNPostalAddress* postAddress = value.value;
        address.state = postAddress.state;
        address.street = postAddress.street;
        address.country = postAddress.country;
        address.countryCode = postAddress.ISOCountryCode;
        address.city = postAddress.city;
        address.zip = postAddress.postalCode;
        return address;
    }];
}

- (NSArray *)socialProfiles
{
    return [self mapMultiValueOfProperty:self.contactRef.socialProfiles withBlock:^id(CNLabeledValue *value) {
        MFSocialProfile* profile = [[MFSocialProfile alloc] init];
        CNSocialProfile* social = value.value;
        profile.socialNetwork = [self socialNetworkTypeWithString:social.service];
        profile.username = social.username;
        profile.url = [NSURL URLWithString:social.urlString];
        profile.userIdentifier = social.userIdentifier;
        return profile;
    }];
}

- (NSDate*)birthday{
    return self.contactRef.birthday.date;
}

- (NSArray*)websites{
    return [self mapMultiValueOfProperty:self.contactRef.urlAddresses withBlock:^id(CNLabeledValue *value) {
        return value.value;
    }];
}

- (NSString*)note{
    return self.contactRef.note;
}

- (NSArray *)relatedPersons
{
    return [self mapMultiValueOfProperty:self.contactRef.contactRelations withBlock:^id(CNLabeledValue *value) {
        MFRelatedPerson* person = [[MFRelatedPerson alloc] init];
        CNContactRelation* relation = value.value;
        person.name = relation.name;
        person.originalLabel = value.label;
        person.localizedLabel = [self localizedLabelFromOriginalValue:value.label];
        return person;
    }];
}

- (NSArray *)dates
{
    return [self mapMultiValueOfProperty:self.contactRef.dates withBlock:^id(CNLabeledValue *value) {
        NSDateComponents* component = value.value;
        MFContactDate* date = [[MFContactDate alloc] init];
        date.date = component.date;
        date.originalLabel = value.label;
        date.localizedLabel = [self localizedLabelFromOriginalValue:value.label];
        return date;
    }];
}

- (NSData *)photo{
    return self.contactRef.thumbnailImageData;
}

#pragma mark - private

- (NSString *)localizedLabelFromOriginalValue:(NSString*)originalLabel
{
    return [CNLabeledValue localizedStringForLabel:originalLabel];
}

- (NSArray *)mapMultiValueOfProperty:(id)mutiValue
                           withBlock:(id (^)(CNLabeledValue* value))block
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (mutiValue)
    {
        NSArray* mutiValueArray = (NSArray*)mutiValue;
        for (CNLabeledValue* value in mutiValueArray) {
            id object = block(value);
            if (object)
            {
                [array addObject:object];
            }
        }
    }
    
    return array.count > 0 ? array.copy : nil;
}

- (MFSocialNetworkType)socialNetworkTypeWithString:(NSString *)string
{
    if ([string isEqualToString:CNSocialProfileServiceFacebook])
    {
        return MFSocialNetworkFacebook;
    }
    else if ([string isEqualToString:CNSocialProfileServiceTwitter])
    {
        return MFSocialNetworkTwitter;
    }
    else if ([string isEqualToString:CNSocialProfileServiceLinkedIn])
    {
        return MFSocialNetworkLinkedIn;
    }
    else if ([string isEqualToString:CNSocialProfileServiceFlickr])
    {
        return MFSocialNetworkFlickr;
    }
    else if ([string isEqualToString:CNSocialProfileServiceGameCenter])
    {
        return MFSocialNetworkGameCenter;
    }
    else if ([string isEqualToString:CNSocialProfileServiceTencentWeibo])
    {
        return MFSocialNetworkTencentWeibo;
    }
    else if ([string isEqualToString:CNSocialProfileServiceSinaWeibo])
    {
        return MFSocialNetworkSinaWeibo;
    }
    else if ([string isEqualToString:CNSocialProfileServiceYelp])
    {
        return MFSocialNetworkYelp;
    }
    else if ([string isEqualToString:CNSocialProfileServiceMySpace])
    {
        return MFSocialNetworkMySpace;
    }
    else
    {
        return MFSocialNetworkUnknown;
    }
}

@end
