MFContacts
==============

[![Build Status](https://api.travis-ci.org/Alterplay/APAddressBook.svg)](https://travis-ci.org/Alterplay/APAddressBook)
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/chenliming777/LFLiveKit/master/LICENSE)&nbsp;
[![Support](https://img.shields.io/badge/ios-7-orange.svg)](https://www.apple.com/nl/ios/)&nbsp;
![platform](https://img.shields.io/badge/platform-ios-ff69b4.svg)&nbsp;

MFContact is a wrapper both on [AddressBook.framework](https://developer.apple.com/library/ios/documentation/AddressBook/Reference/AddressBook_iPhoneOS_Framework/_index.html) and [Contacts.framework]() that gives the same APIs accross two framework and easy way to access the native address book.

#### Features
* Load、modify、delete contacts from iOS address book asynchronously
* Decide what contact data fields you need to read (for example, only name and phone number)
* Sort contacts with array of any [NSSortDescriptor](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/NSSortDescriptor_Class/Reference/Reference.html)

**Installation**

    1. Download all the files in the `MFContacts` subdirectory.
    2. Add the source files to your Xcode project.
    3. In iOS 10.0 and after you need include the `NSContactsUsageDescription` key in your app’s `Info.plist` file and provide a purpose string for this key.

**Read contacts**  

	__weak __typeof(self) weakSelf = self;
	[[MFContactsManager shareManager] readContacts:^(NSArray<MFContact *> *contacts, NSError *error) {
	   if (contacts){
	       [weakSelf.contacts removeAllObjects];
	       [weakSelf.contacts addObjectsFromArray:contacts];
	       [weakSelf.tableView reloadData];
	       NSLog(@"load contact success!");
	   } else if (error) {
	       NSLog(@"load contact failed!");
	   }
	}];


> Callback block will be run on main queue! If you need to run callback block on custom queue use `readContactsOnQueue:completion:` method

