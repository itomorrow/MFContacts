//
//  MFTypes.h
//  MFContacts
//
//  Created by Mason on 16/9/21.
//  Copyright © 2016年 Mason. All rights reserved.
//

#define USE_NEWFRAMEWORK

typedef NS_ENUM(NSUInteger, MFAddressBookAccess)
{
    MFAddressBookAccessUnknown = 0,
    MFAddressBookAccessGranted = 1,
    MFAddressBookAccessDenied  = 2
};

typedef NS_OPTIONS(NSUInteger, MFContactField)
{
    MFContactFieldName                  = 1 << 0,
    MFContactFieldJob                   = 1 << 1,
    MFContactFieldThumbnail             = 1 << 2,
    MFContactFieldPhonesOnly            = 1 << 3,
    MFContactFieldPhonesWithLabels      = 1 << 4,
    MFContactFieldEmailsOnly            = 1 << 5,
    MFContactFieldEmailsWithLabels      = 1 << 6,
    MFContactFieldAddressesWithLabels   = 1 << 7,
    MFContactFieldAddressesOnly         = 1 << 8,
    MFContactFieldSocialProfiles        = 1 << 9,
    MFContactFieldBirthday              = 1 << 10,
    MFContactFieldNote                  = 1 << 11,
    MFContactFieldRelatedPersons        = 1 << 12,
    MFContactFieldLinkedRecordIDs       = 1 << 13,
    MFContactFieldSource                = 1 << 14,
    MFContactFieldDates                 = 1 << 15,
    MFContactFieldRecordDate            = 1 << 16,
    MFContactFieldIdentifier            = 1 << 17,
    MFContactFieldDefault               = MFContactFieldName | MFContactFieldPhonesOnly,
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
