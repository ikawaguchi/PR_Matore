//
//  PRTBlogTableViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRTBlogTableViewController.h"
#import <HTMLParser.h>

@interface PRTBlogTableViewController ()

@property (nonatomic) NSMutableArray *titles;
@property (nonatomic) NSMutableArray *articleUrls;
@property (nonatomic) NSMutableArray *themes;
@property (nonatomic) NSMutableArray *updates;


@end

@implementation PRTBlogTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //http://rssblog.ameba.jp/partyrockets/rss.html
    NSURL *url = [NSURL URLWithString:@"http://ameblo.jp/partyrockets/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"%@", operation.responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:responseObject error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        for (HTMLNode *node in aNodes) {
            if([[node getAttributeNamed:@"class"] isEqualToString:@"skinArticleTitle"]){
                NSLog(@"%@ %@", [node getAttributeNamed:@"href"],[node contents]);
//                NSLog(@"%@", [node contents]); //Answer to second question
            }
        }
        
        
        /*
        NSArray *spanNodes = [bodyNode findChildTags:@"span"];
        
        for (HTMLNode *spanNode in spanNodes) {
            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
                NSLog(@"%@", [spanNode rawContents]); //Answer to second question
            }
        }
        */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    [operation start];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
