//
//  MFAddressBookDataExtractor.h
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

@interface MFAddressBookDataExtractor : NSObject

@property (nonatomic, assign) ABRecordRef recordRef;

- (MFName *)name;
- (MFJob *)job;
- (NSArray *)phones;
- (NSArray *)emails;
- (NSArray *)addresses;
- (NSArray *)socialProfiles;
- (NSArray *)relatedPersons;
- (NSArray *)linkedRecordIDs;
- (MFSource *)source;
- (NSArray *)dates;
- (MFRecordDate *)recordDate;
- (NSArray*)websites;
- (NSString *)stringProperty:(ABPropertyID)property;
- (NSArray *)arrayProperty:(ABPropertyID)property;
- (NSDate *)dateProperty:(ABPropertyID)property;

- (UIImage *)photo;

@end
