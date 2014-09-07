//
//  PRTBlogTableViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMBlogTableViewController.h"
#import "PRMBlogDataManager.h"
#import <HTMLParser.h>


NS_ENUM(NSInteger, PRMTableTag){
    PRMTableTitleLabel = 1,
    PRMTableUpdateLabel = 2,
    PRMTableThemeLabel = 3,
    PRMTableImageView = 4,
};


static NSString *const PRMBaseUrl = @"http://ameblo.jp/partyrockets/";

@interface PRMBlogTableViewController ()

@property (nonatomic) PRMBlogDataManager *dataManager;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger maxPageNum;
@property (nonatomic) BOOL isFetch;

@end

@implementation PRMBlogTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataManager = [PRMBlogDataManager new];
    
    // TableViewの空のセルのところの境界線が消えるおまじない
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];
    
    // BackButtonのタイトルを消す
    //UIBarButtonItem *backButton = self.navigationItem.backBarButtonItem;
    //backButton.title = @"";
    //[self.navigationItem setBackBarButtonItem:backButton];
    
    [self fetchData:1 maxPageNum:10];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 //   [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)fetchData:(NSInteger)count maxPageNum:(NSInteger)maxPageNum{
    self.isFetch = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page-%ld.html",PRMBaseUrl,(long)count]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@", operation.responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:responseObject error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        for (HTMLNode *node in aNodes) {
            if([[node getAttributeNamed:@"class"] isEqualToString:@"skinArticleTitle"]){
                [self.dataManager addTitlesObject:[node contents]];
                [self.dataManager addArticleUrlsObject:[node getAttributeNamed:@"href"]];
            }
            if([[node getAttributeNamed:@"rel"] isEqualToString:@"tag"]){
                [self.dataManager addThemesObject:[node contents]];
            }
            
        }
        
        NSArray *times = [bodyNode findChildTags:@"time"];
        for (HTMLNode *node in times){
            [self.dataManager addUpdatesObject:[node getAttributeNamed:@"datetime"]];
        }
        
        /*
        NSArray *articleTexts = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"articleText" allowPartial:YES];
        for (HTMLNode *node in articleTexts){
            NSLog(@"%@",[node description]);
        }
        */
        
        //NSLog(@"%@ \n %@ \n %@ \n %@",self.dataManager.titles,self.dataManager.articleUrls,
        //      self.dataManager.themes,self.dataManager.updates);
        NSLog(@"count %ld",count);

        
        [self.tableView reloadData];
        
        if(count != maxPageNum){
            [self fetchData:count+1 maxPageNum:maxPageNum];
        }
        else{
            self.maxPageNum = maxPageNum;
            self.isFetch = NO;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isFetch = NO;
        NSLog(@"%@", error.localizedDescription);
    }];
    [operation start];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataManager count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prototypeIdentifier" forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:PRMTableTitleLabel];
    [titleLabel setText:self.dataManager.titles[indexPath.row]];
    UILabel *updateLabel = (UILabel *)[cell.contentView viewWithTag:PRMTableUpdateLabel];
    [updateLabel setText:self.dataManager.updates[indexPath.row]];
    UILabel *themeLabel = (UILabel *)[cell.contentView viewWithTag:PRMTableThemeLabel];
    [themeLabel setText:self.dataManager.themes[indexPath.row]];
    
    UIImageView *thumbnailImageView = (UIImageView *)[cell.contentView viewWithTag:PRMTableImageView];
    if([self.dataManager.themes[indexPath.row] isEqualToString:@"ハルカ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"haru"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"フミカ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"fumi"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"アカリ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"akari"]];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // ハイライト解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[PRMAppDefaults currentDefaults] setBlogOpenUrl:self.dataManager.articleUrls[indexPath.row]];
    [[PRMAppDefaults currentDefaults] setBlogOpenTitle:self.dataManager.titles[indexPath.row]];
    
}

// TODO: webView内スクロール中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"contentsize %lf offset %lf",scrollView.contentSize.height,scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height){
        if(self.isFetch == NO){
            [self fetchData:self.maxPageNum+1 maxPageNum:self.maxPageNum+10];
        }
        
    }
}



@end
