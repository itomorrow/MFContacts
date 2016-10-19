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
- (NSArray *)phonesWithLabels:(BOOL)needLabels;
- (NSArray *)emailsWithLabels:(BOOL)needLabels;
- (NSArray *)addressesWithLabels:(BOOL)labels;
- (NSArray *)socialProfiles;
- (NSArray *)relatedPersons;
- (NSArray *)linkedRecordIDs;
- (MFSource *)source;
- (NSArray *)dates;
- (MFRecordDate *)recordDate;
- (NSString *)stringProperty:(ABPropertyID)property;
- (NSArray *)arrayProperty:(ABPropertyID)property;
- (NSDate *)dateProperty:(ABPropertyID)property;

- (UIImage *)thumbnail;
- (UIImage *)photo;

@end
