//
//  MFContactsModels.h
//  AddressBook
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>
#import "MFTypes.h"


@interface MFAddressBookRefWrapper : NSObject

@property (nullable, nonatomic, readonly) ABAddressBookRef ref;

@end

@class MFName;
@class MFJob;
@class MFPhone;
@class MFEmail;
@class MFAddress;
@class MFSocialProfile;
@class MFRelatedPerson;
@class MFSource;
@class MFContactDate;
@class MFRecordDate;
@class MFWebSite;



@interface MFContact : NSObject

/*! For Contacts Framework, The identifier is unique among contacts on the device. It can be saved and used for fetching contacts next application launch.
    For AddressBook framework, it is RecordID (NSUInteger value) and not unique among contacts, The Apple suggest developer to identified use RecordID+Name in local
 */
@property (nonnull, nonatomic, strong) NSString *identifier;
@property (nullable, nonatomic, strong) MFName *name;
@property (nullable, nonatomic, strong) MFJob *job;
@property (nullable, nonatomic, strong) UIImage *photo;
@property (nullable, nonatomic, strong) NSArray <MFPhone *> *phones;
@property (nullable, nonatomic, strong) NSArray <MFEmail *> *emails;
@property (nullable, nonatomic, strong) NSArray <MFAddress *> *addresses;
@property (nullable, nonatomic, strong) NSArray <MFSocialProfile *> *socialProfiles;
@property (nullable, nonatomic, strong) NSArray <MFWebSite *> *websites;
@property (nullable, nonatomic, strong) NSDate *birthday;
@property (nullable, nonatomic, strong) NSString *note;
@property (nullable, nonatomic, strong) NSArray <MFRelatedPerson *> *relatedPersons;
@property (nullable, nonatomic, strong) NSArray <NSNumber *> *linkedRecordIDs; // addressbook
@property (nullable, nonatomic, strong) MFSource *source; // addressbook
@property (nullable, nonatomic, strong) NSArray <MFContactDate *> *dates;
@property (nullable, nonatomic, strong) MFRecordDate *recordDate; // addressbook

@end


@interface MFName : NSObject

- (nullable instancetype)initWithFirstName:(nullable NSString*)firstName lastName:(nullable NSString*)lastName;

@property (nullable, nonatomic, strong) NSString *firstName;
@property (nullable, nonatomic, strong) NSString *lastName;
@property (nullable, nonatomic, strong) NSString *middleName;
@property (nullable, nonatomic, strong) NSString *compositeName;

@end


@interface MFJob : NSObject

@property (nullable, nonatomic, strong) NSString *orgnazition;
@property (nullable, nonatomic, strong) NSString *department;
@property (nullable, nonatomic, strong) NSString *jobTitle;

@end



@interface MFPhone : NSObject

@property (nullable, nonatomic, strong) NSString *number;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end


@interface MFEmail : NSObject

@property (nullable, nonatomic, strong) NSString *address;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end

@interface MFAddress : NSObject

@property (nullable, nonatomic, strong) NSString *street;
@property (nullable, nonatomic, strong) NSString *city;
@property (nullable, nonatomic, strong) NSString *state;
@property (nullable, nonatomic, strong) NSString *zip;
@property (nullable, nonatomic, strong) NSString *country;
@property (nullable, nonatomic, strong) NSString *countryCode;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end

@interface MFWebSite : NSObject

@property (nullable, nonatomic, strong) NSString *website;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end


@interface MFSocialProfile : NSObject

@property (nonatomic, assign) MFSocialNetworkType socialNetwork;
@property (nullable, nonatomic, strong) NSString *username;
@property (nullable, nonatomic, strong) NSString *userIdentifier;
@property (nullable, nonatomic, strong) NSURL *url;

@end


@interface MFRelatedPerson : NSObject

@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end


@interface MFSource : NSObject

@property (nonnull, nonatomic, strong) NSString *sourceType;
@property (nonnull, nonatomic, strong) NSNumber *sourceID;

@end


@interface MFContactDate : NSObject

@property (nullable, nonatomic, strong) NSDate *date;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end


@interface MFRecordDate : NSObject

@property (nonnull, nonatomic, strong) NSDate *creationDate;
@property (nonnull, nonatomic, strong) NSDate *modificationDate;

@end
