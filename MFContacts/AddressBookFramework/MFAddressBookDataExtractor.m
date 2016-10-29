//
//  MFAddressBookDataExtractor.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookDataExtractor.h"
#import "MFContactsModels.h"


@implementation MFAddressBookDataExtractor

#pragma mark - public

- (nullable MFName *)name
{
    MFName *name = [[MFName alloc] init];
    name.firstName = [self stringProperty:kABPersonFirstNameProperty];
    name.lastName = [self stringProperty:kABPersonLastNameProperty];
    name.middleName = [self stringProperty:kABPersonMiddleNameProperty];
    name.compositeName = [self compositeName];
    return name;
}

- (MFJob *)job
{
    MFJob *job = [[MFJob alloc] init];
    job.orgnazition = [self stringProperty:kABPersonOrganizationProperty];
    job.department = [self stringProperty:kABPersonDepartmentProperty];
    job.jobTitle = [self stringProperty:kABPersonJobTitleProperty];
    return job;
}

- (NSArray *)phones
{
    return [self mapMultiValueOfProperty:kABPersonPhoneProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        MFPhone *phone;
        if (value)
        {
            phone = [[MFPhone alloc] init];
            phone.number = (__bridge NSString *)value;
            phone.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            phone.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        }
        return phone;
    }];
}

- (NSArray *)emails
{
    return [self mapMultiValueOfProperty:kABPersonEmailProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        MFEmail *email;
        if (value)
        {
            email = [[MFEmail alloc] init];
            email.address = (__bridge NSString *)value;
            email.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            email.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        }
        return email;
    }];
}

- (NSArray *)addresses
{
    return [self mapMultiValueOfProperty:kABPersonAddressProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        NSDictionary *dictionary = (__bridge NSDictionary *)value;
        MFAddress *address = [[MFAddress alloc] init];
        address.street = dictionary[(__bridge NSString *)kABPersonAddressStreetKey];
        address.city = dictionary[(__bridge NSString *)kABPersonAddressCityKey];
        address.state = dictionary[(__bridge NSString *)kABPersonAddressStateKey];
        address.zip = dictionary[(__bridge NSString *)kABPersonAddressZIPKey];
        address.country = dictionary[(__bridge NSString *)kABPersonAddressCountryKey];
        address.countryCode = dictionary[(__bridge NSString *)kABPersonAddressCountryCodeKey];
        address.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
        address.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        return address;
    }];
}

- (NSArray *)socialProfiles
{
    NSMutableArray *profiles = [[NSMutableArray alloc] init];
    NSArray *array = [self arrayProperty:kABPersonSocialProfileProperty];
    for (NSDictionary *dictionary in array)
    {
        MFSocialProfile *profile = [[MFSocialProfile alloc] init];
        NSString *socialService = dictionary[(__bridge NSString *)kABPersonSocialProfileServiceKey];
        profile.socialNetwork = [self socialNetworkTypeWithString:socialService];
        profile.url = dictionary[(__bridge NSString *)kABPersonSocialProfileURLKey];
        profile.username = dictionary[(__bridge NSString *)kABPersonSocialProfileUsernameKey];
        profile.userIdentifier = dictionary[(__bridge NSString *)kABPersonSocialProfileUserIdentifierKey];
        [profiles addObject:profile];
    }
    return profiles.copy;
}

- (NSArray *)relatedPersons
{
    return [self mapMultiValueOfProperty:kABPersonRelatedNamesProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        MFRelatedPerson *relatedPerson;
        if (value)
        {
            relatedPerson = [[MFRelatedPerson alloc] init];
            relatedPerson.name = (__bridge NSString *)value;
            relatedPerson.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            relatedPerson.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        }
        return relatedPerson;
    }];
}

- (NSArray *)linkedRecordIDs
{
    NSMutableOrderedSet *linkedRecordIDs = [[NSMutableOrderedSet alloc] init];
    CFArrayRef linkedPeopleRef = ABPersonCopyArrayOfAllLinkedPeople(self.recordRef);
    CFIndex count = CFArrayGetCount(linkedPeopleRef);
    NSNumber *contactRecordID = @(ABRecordGetRecordID(self.recordRef));
    for (CFIndex i = 0; i < count; i++)
    {
        ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleRef, i);
        NSNumber *linkedRecordID = @(ABRecordGetRecordID(linkedRecordRef));
        if (![linkedRecordID isEqualToNumber:contactRecordID])
        {
            [linkedRecordIDs addObject:linkedRecordID];
        }
    }
    CFRelease(linkedPeopleRef);
    return linkedRecordIDs.array;
}

- (MFSource *)source
{
    MFSource *source;
    ABRecordRef sourceRef = ABPersonCopySource(self.recordRef);
    if (sourceRef)
    {
        source = [[MFSource alloc] init];
        source.sourceType = [self stringProperty:kABSourceNameProperty fromRecordRef:sourceRef];
        source.sourceID =  @(ABRecordGetRecordID(sourceRef));
        CFRelease(sourceRef);
    }
    return source;
}

- (NSArray *)dates
{
    return [self mapMultiValueOfProperty:kABPersonDateProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        MFContactDate *date;
        if (value)
        {
            date = [[MFContactDate alloc] init];
            date.date = (__bridge NSDate *)value;
            date.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
            date.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
        }
        return date;
    }];
}

- (MFRecordDate *)recordDate
{
    MFRecordDate *recordDate = [[MFRecordDate alloc] init];
    recordDate.creationDate = [self dateProperty:kABPersonCreationDateProperty];
    recordDate.modificationDate = [self dateProperty:kABPersonModificationDateProperty];
    return recordDate;
}

- (NSArray *)websites{
    return [self mapMultiValueOfProperty:kABPersonURLProperty
                               withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
            {
                MFWebSite *web;
                if (value)
                {
                    web = [[MFWebSite alloc] init];
                    web.website = (__bridge NSString*)value;
                    web.originalLabel = [self originalLabelFromMultiValue:multiValue index:index];
                    web.localizedLabel = [self localizedLabelFromMultiValue:multiValue index:index];
                }
                return web;
            }];
}

- (NSString *)stringProperty:(ABPropertyID)property
{
    return [self stringProperty:property fromRecordRef:self.recordRef];
}

- (NSArray *)arrayProperty:(ABPropertyID)property
{
    return [self mapMultiValueOfProperty:property withBlock:^id(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index)
    {
        return (__bridge NSString *)value;
    }];
}

- (NSDate *)dateProperty:(ABPropertyID)property
{
    CFDateRef dateRef = ABRecordCopyValue(self.recordRef, property);
    return (__bridge_transfer NSDate *)dateRef;
}

- (NSData *)photo{
    return [MFAddressBookDataExtractor imageWithRecordRef:self.recordRef fullSize:YES];
}

#pragma mark - private
- (NSString *)compositeName
{
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(self.recordRef);
    return (__bridge_transfer NSString *)compositeNameRef;
}

- (NSString *)originalLabelFromMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    NSString *label = (__bridge_transfer NSString *)rawLabel;
    return label;
}

- (NSString *)localizedLabelFromMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    NSString *label;
    CFTypeRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, index);
    if (rawLabel)
    {
        CFStringRef localizedLabel = ABAddressBookCopyLocalizedLabel(rawLabel);
        if (localizedLabel)
        {
            label = (__bridge_transfer NSString *)localizedLabel;
        }
        CFRelease(rawLabel);
    }
    return label;
}

- (NSArray *)mapMultiValueOfProperty:(ABPropertyID)property
                           withBlock:(id (^)(ABMultiValueRef multiValue, CFTypeRef value, CFIndex index))block
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(self.recordRef, property);
    if (multiValue)
    {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++)
        {
            CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, i);
            id object = block(multiValue, value, i);
            if (object)
            {
                [array addObject:object];
            }
            CFRelease(value);
        }
        CFRelease(multiValue);
    }
    return array.count > 0 ? array.copy : nil;
}

- (NSString *)stringProperty:(ABPropertyID)property fromRecordRef:(ABRecordRef)recordRef
{
    CFTypeRef valueRef = (ABRecordCopyValue(recordRef, property));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSData *)imageWithRecordRef:(ABRecordRef)recordRef fullSize:(BOOL)isFullSize
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
    kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return data;
    //return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (MFSocialNetworkType)socialNetworkTypeWithString:(NSString *)string
{
    if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFacebook])
    {
        return MFSocialNetworkFacebook;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceTwitter])
    {
        return MFSocialNetworkTwitter;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceLinkedIn])
    {
        return MFSocialNetworkLinkedIn;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFlickr])
    {
        return MFSocialNetworkFlickr;
    }
    else if ([string isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceGameCenter])
    {
        return MFSocialNetworkGameCenter;
    }
    else
    {
        return MFSocialNetworkUnknown;
    }
}


@end
