//
//  PRTBlogTableViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMFavoriteTableViewController.h"
#import "PRMBlogDataManager.h"


NS_ENUM(NSInteger, PRMTableTag){
    PRMTableTitleLabel = 1,
    PRMTableUpdateLabel = 2,
    PRMTableThemeLabel = 3,
    PRMTableImageView = 4,
};

static NSInteger const PRMTableHeight = 80;

@interface PRMFavoriteTableViewController ()

@property (nonatomic) PRMBlogDataManager *dataManager;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger maxPageNum;
@property (nonatomic) BOOL isFetch;

//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes
@property (nonatomic) BOOL reloading;

@end

@implementation PRMFavoriteTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataManager = [PRMBlogDataManager new];
    self.dataManager.articleUrls = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    self.dataManager.titles = [[PRMAppDefaults currentDefaults] favoriteBlogTitles];
    self.dataManager.themes = [[PRMAppDefaults currentDefaults] favoriteBlogThemes];
    self.dataManager.updates = [[PRMAppDefaults currentDefaults] favoriteBlogUpdates];
    
    // TableViewの空のセルのところの境界線が消えるおまじない
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.layer.cornerRadius = 10.0f;
    if([self.dataManager.themes[indexPath.row] isEqualToString:@"ハルカ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"haru"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"フミカ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"fumi"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"アカリ日記"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"akari"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"ARISAブログ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"ari"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"HIMEKAブログ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"hime"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"NANASEブログ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"nana"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"AYUMIブログ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"ayu"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"ブログ"] ||
            [self.dataManager.themes[indexPath.row] isEqualToString:@"お知らせ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"all"]];
    }

    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PRMTableHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // ハイライト解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[PRMAppDefaults currentDefaults] setBlogOpenUrl:self.dataManager.articleUrls[indexPath.row]];
    [[PRMAppDefaults currentDefaults] setBlogOpenTitle:self.dataManager.titles[indexPath.row]];
    
}

-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController: (UIViewController*)viewController{
    if(tabBarController.selectedIndex == 0){
//        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    
}




@end
