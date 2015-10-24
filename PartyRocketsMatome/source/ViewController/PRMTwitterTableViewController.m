//
//  PRMTwitterTableViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/07.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMTwitterTableViewController.h"
#import "PRMTwitterTimeLineModel.h"
#import "PRMTwitterParser.h"

#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountStore.h>
#import <Social/SLRequest.h>


static NSString *const twitterBaseUrl = @"https://api.twitter.com/1.1/statuses/";
static NSString *const twitterUserTimeLine = @"user_timeline.json";


NS_ENUM(NSInteger, PRMTwitterType){
    PRMTwitterTimeLine = 0,
};


NS_ENUM(NSInteger, PRMTwitterTableTag){
    PRMTwitterMainText = 1,
};


@interface PRMTwitterTableViewController()

@property (nonatomic) NSMutableArray *timeLineModels;

@end



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
    self.timeLineModels = [NSMutableArray array];


    [self fetchTwitterParam:PRMTwitterTimeLine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.timeLineModels count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PRMTwitterTimeLineModel *model = self.timeLineModels[indexPath.row];
  //  NSLog(@"height %lf",model.tableHeight);
    return model.tableHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prototypeIdentifier" forIndexPath:indexPath];
    PRMTwitterTimeLineModel *model = self.timeLineModels[indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:PRMTwitterMainText];
    [titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y,
                                    titleLabel.frame.size.width, cell.frame.size.height)];
    [titleLabel setText:model.mainText];
//    [titleLabel sizeToFit];
    
    return cell;
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
                                                        
                                                        switch (TwitterType) {
                                                            case PRMTwitterTimeLine:
                                                                [self.timeLineModels addObjectsFromArray:[PRMTwitterParser parse:jsonData]];
                                                                [self.tableView reloadData];
                                                                [self.tableView setNeedsDisplay];
                                                                break;
                                                                
                                                            default:
                                                                break;
                                                        }
                                                        
                                                        
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
