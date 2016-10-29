//
//  MFRootViewController.m
//  MFContactsDemo
//
//  Created by Mason on 2016/10/17.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "MFRootViewController.h"
#import "MFContactsManager.h"

@interface MFRootViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* contacts;
@end

@implementation MFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Contacts";
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.tableView];
    
    [[MFContactsManager shareManager] startObserveChangesWithCallback:^{
        NSLog(@"contacts has changed");
        [self loadContacts];
    }];
    
    [self loadContacts];
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(onAdd)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private func
- (void)loadContacts
{
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
}

- (void)onAdd{
    
    MFContact* contact = [[MFContact alloc] init];
    
    contact.name = [[MFName alloc] initWithFirstName:@"Bob" lastName:@"Dylan"];

    
    contact.job = [[MFJob alloc] init];
    contact.job.jobTitle = @"Musician";
    contact.job.department = @"Creative";
    contact.job.orgnazition = @"Gelubie";
    
    contact.photo = [UIImage imageNamed:@"pic.jpg"];
    
    MFPhone* phone1 = [[MFPhone alloc] init];
    phone1.number = @"13834234323";
    phone1.originalLabel = (NSString*)kABPersonPhoneMobileLabel;
    MFPhone* phone2 = [[MFPhone alloc] init];
    phone2.number = @"13453332234";
    phone2.originalLabel = (NSString*)kABPersonPhoneIPhoneLabel;
    contact.phones = @[phone1, phone2];
    
    
    MFEmail* mail1 = [[MFEmail alloc] init];
    mail1.address = @"BobDylan@gmail.com";
    mail1.originalLabel = (NSString*)kABWorkLabel;
    MFEmail* mail2 = [[MFEmail alloc] init];
    mail2.address = @"243323422@qq.com";
    mail2.originalLabel = (NSString*)kABWorkLabel;
    contact.emails = @[mail1, mail2];
    
    MFAddress* add1 = [[MFAddress alloc] init];
    add1.country = @"中国";
    add1.state = @"朝阳";
    add1.street = @"望京soho";
    add1.city = @"北京";
    add1.zip = @"110100";
    add1.originalLabel = (NSString*)kABHomeLabel;
    
    MFAddress* add2 = [[MFAddress alloc] init];
    add2.country = @"中国";
    add2.state = @"海淀";
    add2.street = @"中关村东路";
    add2.city = @"北京";
    add2.zip = @"110100";
    add2.originalLabel = (NSString*)kABWorkLabel;
    contact.addresses = @[add1, add2];
    
    contact.birthday = [NSDate date];
    
    contact.note = @"really note consume";
    
    MFContactDate* conDate1 = [[MFContactDate alloc] init];
    conDate1.date = [NSDate date];
    conDate1.originalLabel = @"创作时间";
    contact.dates = @[conDate1];

    MFSocialProfile* profile1 = [[MFSocialProfile alloc] init];
    profile1.socialNetwork = MFSocialNetworkFlickr;
    profile1.username = @"wangbai";
    profile1.url = [NSURL URLWithString:@"www.baidu.com"];

    MFSocialProfile* profile2 = [[MFSocialProfile alloc] init];
    profile2.socialNetwork = MFSocialNetworkFacebook;
    profile2.username = @"lixuan";
    profile2.url = [NSURL URLWithString:@"www.sina.com"];
    contact.socialProfiles = @[profile1, profile2];

    MFRelatedPerson* rePerson1 = [[MFRelatedPerson alloc] init];
    rePerson1.name = @"baiyu";
    rePerson1.originalLabel = @"同事";
    contact.relatedPersons = @[rePerson1];
    
    
    [[MFContactsManager shareManager] writeContact:contact completion:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MFContact* contact = [self.contacts objectAtIndex:indexPath.row];
    NSLog(@"You touch the contact of %@", contact.name.compositeName);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"UITableViewCellContact";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MFContact* contact = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.name.compositeName;
    cell.imageView.image = contact.photo;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MFContact* contact = [self.contacts objectAtIndex:indexPath.row];
        [[MFContactsManager shareManager] removeContactByIdentifier:contact.identifier completion:^(NSError * _Nullable error) {
            NSLog(@"removed!");
        }];
        
        [self.contacts removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma makr - Getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
    }
    return _tableView;
}

- (NSMutableArray *)contacts{
    if (!_contacts) {
        _contacts = [[NSMutableArray alloc] init];
    }
    return _contacts;
}

@end
