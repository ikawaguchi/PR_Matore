//
//  PRMTwitterTableViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/07.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMTwitterTableViewController.h"

#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountStore.h>
#import <Social/SLRequest.h>


static NSString *const twitterBaseUrl = @"https://api.twitter.com/1.1/statuses/";
static NSString *const twitterUserTimeLine = @"user_timeline.json";


NS_ENUM(NSInteger, PRMTwitterType){
    PRMTwitterTimeLine = 0,
};


@interface PRMTwitterTableViewController ()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation PRMTwitterTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TableViewの空のセルのところの境界線が消えるおまじない
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];

    self.accountStore = [ACAccountStore new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchTwitterParam:PRMTwitterTimeLine];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}


- (void)fetchTwitterParam:(NSInteger)TwitterType {
    ACAccountType* accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError* error) {
                                                if (error) {
                                                    NSLog(@"%@", error);
                                                    return;
                                                }
                                                
                                                NSArray* accounts = [self.accountStore accountsWithAccountType:accountType];
                                                if (accounts.count == 0) return;
                                                
                                                
                                                
                                                NSURL* url;
                                                NSDictionary* params;
                                                switch (TwitterType) {
                                                    case PRMTwitterTimeLine:
                                                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",twitterBaseUrl,twitterUserTimeLine]];
                                                        params = @{@"screen_name" : @"Party_Rockets",
                                                                   @"count" : @"120" };
                                                        break;
                                                        
                                                    default:
                                                        break;
                                                }
                                                
                                                
                                                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                                        requestMethod:SLRequestMethodGET
                                                                                                  URL:url
                                                                                           parameters:params];
                                                
                                                request.account = accounts.firstObject;
                                                [request performRequestWithHandler:^(NSData* responseData,
                                                                                     NSHTTPURLResponse* urlResponse,
                                                                                     NSError* error) {
                                                    if (error) {
                                                        NSLog(@"%@, %@", urlResponse, error);
                                                        return;
                                                    }
                                                    
                                                    if (200 <= urlResponse.statusCode && urlResponse.statusCode < 300) {
                                                        
                                                        
                                                        
                                                        NSError* e = nil;
                                                        NSArray* jsonData = [NSJSONSerialization
                                                                             JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments error:&e];
                                                        
                                                        
                                                        for(NSDictionary *childObject in jsonData){
                                                            NSLog(@"%@",[childObject objectForKey:@"text"]);
                                                        }
                                                    } else {
                                                        NSLog(@"%@", urlResponse);
                                                    }
                                                }];
                                            }];
}
     

@end
