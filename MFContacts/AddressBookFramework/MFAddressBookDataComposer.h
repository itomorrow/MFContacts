//
//  MFAddressBookDataComposer.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@class MFName;
@class MFJob;
@class MFSource;
@class MFRecordDate;

@interface MFAddressBookDataComposer : NSObject

@property (nonatomic, assign) ABRecordRef recordRef;

- (void)composeName:(MFName*)name;
- (void)composeJob:(MFJob*)job;
- (void)composePhones:(NSArray*)phones;
- (void)composeEmails:(NSArray*)emails;
- (void)composeAddresses:(NSArray*)addresses;
- (void)composeSocialProfiles:(NSArray*)profiles;
- (void)composeRelatedPersons:(NSArray*)persons;
- (void)composeLinkedRecordIDs:(NSArray*)IDs;
- (void)composeSource:(MFSource*)source;
- (void)composeDates:(NSArray*)dates;
- (void)composeRecordDate:(MFRecordDate*)recordDate;
- (bool)setStringProperty:(ABPropertyID)property withValue:(NSString*)value;
- (bool)setDateProperty:(ABPropertyID)property withValue:(NSDate*)value;

- (void)composeThumbnail:(UIImage *)image;
- (void)compsePhoto:(UIImage *)image;

@end




