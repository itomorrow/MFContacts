//
//  MFTypes.h
//  MFContacts
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//

//#define FORCE_USE_ADDRESSBOOK_FRAMEWORK

typedef NS_ENUM(NSUInteger, MFAddressBookAccess)
{
    MFAddressBookAccessUnknown = 0,
    MFAddressBookAccessGranted = 1,
    MFAddressBookAccessDenied  = 2
};

typedef NS_OPTIONS(NSUInteger, MFContactField)
{
    MFContactFieldIdentifier            = 1 << 0,
    MFContactFieldName                  = 1 << 1,
    MFContactFieldJob                   = 1 << 2,
    MFContactFieldPhoto                 = 1 << 3,
    MFContactFieldPhone                 = 1 << 4,
    MFContactFieldEmail                 = 1 << 5,
    MFContactFieldWebSite               = 1 << 6,
    MFContactFieldAddress               = 1 << 7,
    MFContactFieldSocialProfiles        = 1 << 8,
    MFContactFieldBirthday              = 1 << 9,
    MFContactFieldNote                  = 1 << 10,
    MFContactFieldRelatedPersons        = 1 << 11,
    MFContactFieldLinkedRecordIDs       = 1 << 12,
    MFContactFieldSource                = 1 << 13,
    MFContactFieldDates                 = 1 << 14,
    MFContactFieldRecordDate            = 1 << 15,

    MFContactFieldDefault               = MFContactFieldName | MFContactFieldPhone,
    MFContactFieldAll                   = 0xFFFFFFFF
};

typedef NS_ENUM(NSUInteger, MFSocialNetworkType)
{
    MFSocialNetworkUnknown = 0,
    MFSocialNetworkFacebook = 1,
    MFSocialNetworkTwitter = 2,
    MFSocialNetworkLinkedIn = 3,
    MFSocialNetworkFlickr = 4,
    MFSocialNetworkGameCenter = 5,
    MFSocialNetworkMySpace = 6,
    MFSocialNetworkSinaWeibo = 7,
    MFSocialNetworkTencentWeibo = 8,
    MFSocialNetworkYelp = 9
};
