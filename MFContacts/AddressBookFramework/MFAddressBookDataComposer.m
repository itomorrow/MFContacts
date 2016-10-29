//
//  ASAddressBookDataComposer.m
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MFAddressBookDataComposer.h"
#import "MFContactsModels.h"


@implementation MFAddressBookDataComposer

#pragma mark - public

- (void)composeName:(MFName*)name{
    if (name.firstName.length > 0) {
        [self setStringProperty:kABPersonFirstNameProperty withValue:name.firstName];
    }
    if (name.lastName.length > 0) {
        [self setStringProperty:kABPersonLastNameProperty withValue:name.lastName];
    }
    if (name.middleName.length > 0) {
        [self setStringProperty:kABPersonMiddleNameProperty withValue:name.middleName];
    }
}

- (void)composeJob:(MFJob*)job{
    if (job.orgnazition.length > 0) {
        [self setStringProperty:kABPersonOrganizationProperty withValue:job.orgnazition];
    }
    if (job.department.length > 0) {
        [self setStringProperty:kABPersonDepartmentProperty withValue:job.department];
    }
    if (job.jobTitle.length > 0) {
        [self setStringProperty:kABPersonJobTitleProperty withValue:job.jobTitle];
    }
}

- (void)composePhones:(NSArray*)phones{
    [self setMultiValue:phones OfProperty:kABPersonPhoneProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFPhone* phone = (MFPhone*)srcValue;
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)phone.number, (__bridge CFStringRef)phone.originalLabel, NULL);
        return result;
    }];
}

- (void)composeEmails:(NSArray*)emails{
    [self setMultiValue:emails OfProperty:kABPersonEmailProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFEmail* mail = (MFEmail*)srcValue;
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)mail.address, (__bridge CFStringRef)mail.originalLabel, NULL);
        return result;
    }];
}

- (void)composeAddresses:(NSArray*)addresses{
    [self setMultiValue:addresses OfProperty:kABPersonAddressProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFAddress* address = (MFAddress*)srcValue;
        NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:
                                address.street, (NSString *)kABPersonAddressStreetKey,
                                address.zip, (NSString *)kABPersonAddressZIPKey,
                                address.city, (NSString *)kABPersonAddressCityKey,
                                address.state, (NSString*)kABPersonAddressStateKey,
                                address.country, (NSString*)kABPersonAddressCountryKey,
                                address.countryCode, (NSString*)kABPersonAddressCountryCodeKey,
                                nil];
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFDictionaryRef)values, (__bridge CFStringRef)address.originalLabel, NULL);
        return result;
    }];
}

- (void)composeSocialProfiles:(NSArray*)profiles{
    __weak typeof(self) weakSelf = self;
    [self setMultiValue:profiles OfProperty:kABPersonSocialProfileProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFSocialProfile* social = (MFSocialProfile*)srcValue;
        NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:
                                [weakSelf socialNetworkTypeWithType:social.socialNetwork] , (NSString *)kABPersonSocialProfileServiceKey,
                                social.url, (NSString *)kABPersonSocialProfileURLKey,
                                social.username, (NSString *)kABPersonSocialProfileUsernameKey,
                                social.userIdentifier, (NSString*)kABPersonSocialProfileUserIdentifierKey,
                                nil];
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFDictionaryRef)values, kABHomeLabel, NULL);
        return result;
    }];
}

- (void)composeRelatedPersons:(NSArray*)persons{
    [self setMultiValue:persons OfProperty:kABPersonRelatedNamesProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFRelatedPerson* relatePerson = (MFRelatedPerson*)srcValue;
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)relatePerson.name, (__bridge CFStringRef)relatePerson.originalLabel, NULL);
        return result;
    }];
}

- (void)composeLinkedRecordIDs:(NSArray*)IDs{
//    NSMutableOrderedSet *linkedRecordIDs = [[NSMutableOrderedSet alloc] init];
//    CFArrayRef linkedPeopleRef = ABPersonCopyArrayOfAllLinkedPeople(self.recordRef);
//    CFIndex count = CFArrayGetCount(linkedPeopleRef);
//    NSNumber *contactRecordID = @(ABRecordGetRecordID(self.recordRef));
//    for (CFIndex i = 0; i < count; i++)
//    {
//        ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleRef, i);
//        NSNumber *linkedRecordID = @(ABRecordGetRecordID(linkedRecordRef));
//        if (![linkedRecordID isEqualToNumber:contactRecordID])
//        {
//            [linkedRecordIDs addObject:linkedRecordID];
//        }
//    }
//    CFReleMFe(linkedPeopleRef);
//    return linkedRecordIDs.array;
}

- (void)composeSource:(MFSource*)source{
//    MFSource *source;
//    ABRecordRef sourceRef = ABPersonCopySource(self.recordRef);
//    if (sourceRef)
//    {
//        source = [[MFSource alloc] init];
//        source.sourceType = [self stringProperty:kABSourceNameProperty fromRecordRef:sourceRef];
//        source.sourceID =  @(ABRecordGetRecordID(sourceRef));
//        CFReleMFe(sourceRef);
//    }
//    return source;
}

- (void)composeDates:(NSArray*)dates{
    [self setMultiValue:dates OfProperty:kABPersonDateProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        MFContactDate* contactDate = (MFContactDate*)srcValue;
        bool result = NO;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFDateRef)contactDate.date, (__bridge CFStringRef)contactDate.originalLabel, NULL);
        return result;
    }];
}

- (void)composeWebsites:(NSArray*)sites{
    [self setMultiValue:sites OfProperty:kABPersonURLProperty withBlock:^bool(ABMultiValueRef multiValue, id srcValue) {
        bool result = NO;
        MFWebSite* website = (MFWebSite*)srcValue;
        result = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)website.website, (__bridge CFStringRef)website.originalLabel, NULL);
        return result;
    }];
}

- (void)composeRecordDate:(MFRecordDate*)recordDate
{
    if (recordDate.creationDate) {
        [self setDateProperty:kABPersonCreationDateProperty withValue:recordDate.creationDate];
    }
    if (recordDate.modificationDate) {
        [self setDateProperty:kABPersonModificationDateProperty withValue:recordDate.modificationDate];
    }
}

- (bool)setStringProperty:(ABPropertyID)property withValue:(NSString*)value
{
    return [self setStringProperty:property withValue:value toRecordRef:self.recordRef];
}

- (bool)setDateProperty:(ABPropertyID)property withValue:(NSDate*)value
{
    CFErrorRef err = NULL;
    bool result = ABRecordSetValue(self.recordRef, property, (__bridge CFDateRef)value, &err);
    return result && err == NULL;
}

- (void)compsePhoto:(UIImage *)image{
    NSData *dataref = UIImagePNGRepresentation(image);
    CFErrorRef error = NULL;
    ABPersonSetImageData(self.recordRef, (__bridge CFDataRef)(dataref), &error);
}

#pragma mark - private
- (bool)setMultiValue:(NSArray*)values OfProperty:(ABPropertyID)property withBlock:(bool (^)(ABMultiValueRef multiValue, id srcValue))block{
    
    // check property type
    ABPropertyType type = kABInvalidPropertyType;
    if (property == kABPersonEmailProperty ||
        property == kABPersonPhoneProperty ||
        property == kABPersonRelatedNamesProperty) {
        type = kABMultiStringPropertyType;
    } else if (property == kABPersonAddressProperty ||
               kABPersonSocialProfileProperty){
        type = kABMultiDictionaryPropertyType;
    } else if (property == kABPersonDateProperty){
        type = kABDateTimePropertyType;
    }
    ABMultiValueRef multiValueRef = ABMultiValueCreateMutable(type);

    // begin buid property by approciate block
    for (int i = 0; i < values.count; ++i) {
        id srcValue = [values objectAtIndex:i];
        block(multiValueRef, srcValue);
    }
    
    // set buid result to record
    CFErrorRef err = NULL;
    bool result = ABRecordSetValue(self.recordRef, property, multiValueRef, &err);
    CFRelease(multiValueRef);
    return result && err == NULL;
}

- (bool)setStringProperty:(ABPropertyID)property withValue:(NSString*)stringValue toRecordRef:(ABRecordRef)recordRef
{
    CFErrorRef err = NULL;
    bool result = ABRecordSetValue(recordRef, property, (__bridge CFStringRef)stringValue, &err);
    return result && err == NULL;
}

+ (UIImage *)imageWithRecordRef:(ABRecordRef)recordRef fullSize:(BOOL)isFullSize
{
    ABPersonImageFormat format = isFullSize ? kABPersonImageFormatOriginalSize :
    kABPersonImageFormatThumbnail;
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(recordRef, format);
    return [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
}

- (NSString*)socialNetworkTypeWithType:(MFSocialNetworkType)type{

    NSString* result = nil;
    if (type == MFSocialNetworkFacebook) {
        result = (__bridge NSString *)kABPersonSocialProfileServiceFacebook;
    }
    if (type == MFSocialNetworkFlickr) {
        result = (__bridge NSString *)kABPersonSocialProfileServiceFlickr;
    }
    if (type == MFSocialNetworkTwitter) {
        result = (__bridge NSString *)kABPersonSocialProfileServiceTwitter;
    }
    if (type == MFSocialNetworkLinkedIn) {
        result = (__bridge NSString *)kABPersonSocialProfileServiceLinkedIn;
    }
    if (type == MFSocialNetworkGameCenter) {
        result = (__bridge NSString *)kABPersonSocialProfileServiceGameCenter;
    }
    return result;
}


@end
