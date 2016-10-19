//
//  MFContactDataExtractor.h
//  MFContacts
//
//  Created by Mason on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

@class MFName;
@class MFJob;
@class MFSource;
@class MFRecordDate;

@interface MFContactDataExtractor : NSObject

@property (nonatomic, weak) CNContact* contactRef;

- (MFName *)name;
- (MFJob *)job;
- (NSArray *)phones;
- (NSArray *)emails;
- (NSArray *)addresses;
- (NSArray *)socialProfiles;
- (NSDate*)birthday;
- (NSArray*)websites;
- (NSString*)note;
- (NSArray *)relatedPersons;
- (NSArray *)dates;
- (UIImage *)thumbnail;

@end
