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
#import <AFNetworking/AFNetworking.h>

#import "PRMFavoriteTableViewController.h"


NS_ENUM(NSInteger, PRMTableTag){
    PRMTableTitleLabel = 1,
    PRMTableUpdateLabel = 2,
    PRMTableThemeLabel = 3,
    PRMTableImageView = 4,
    PRMTableFavoriteButton = 5,
};

static NSInteger const PRMTableHeight = 80;
static NSString *const PRMBaseUrl = @"https://ameblo.jp/partyrockets/";

@interface PRMBlogTableViewController ()

@property (nonatomic) PRMBlogDataManager *dataManager;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger maxPageNum;
@property (nonatomic) BOOL isFetch;

//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes
@property (nonatomic) BOOL reloading;

@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

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
    
    // 引っ張って更新の初期化
    // 更新ビューのサイズとデリゲートを指定する
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  - self.tableView.bounds.size.height + PRMTableHeight, self.view.frame.size.width, self.tableView.bounds.size.height - PRMTableHeight)];
    self.refreshHeaderView.delegate = self;
   [self.tableView addSubview:self.refreshHeaderView];
    
    [self fetchData:1 maxPageNum:10];
    
    //  update the last update date
	[self.refreshHeaderView refreshLastUpdatedDate];
    
    [self.tabBarController setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)fetchData:(NSInteger)count maxPageNum:(NSInteger)maxPageNum{
    self.isFetch = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page-%ld.html",PRMBaseUrl,(long)count]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:responseObject error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        for (HTMLNode *node in aNodes) {
            if([[node getAttributeNamed:@"class"] isEqualToString:@"skinArticleTitle"]){
                [self.dataManager addTitlesObject:[node contents]];
                [self.dataManager addArticleUrlsObject:[node getAttributeNamed:@"href"]];
                [self.dataManager addIsFavorite:[self checkIsFavorite:[node getAttributeNamed:@"href"]]];
            }
            if([[node getAttributeNamed:@"rel"] isEqualToString:@"tag"]){
                [self.dataManager addThemesObject:[node contents]];
            }
        }
        
        NSArray *times = [bodyNode findChildTags:@"time"];
        for (HTMLNode *node in times){
            [self.dataManager addUpdatesObject:[node getAttributeNamed:@"datetime"]];
        }
        
        
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
    //タイトルに空白文字と改行が混じっているためトリミング
    NSString* titleStr = [self.dataManager.titles[indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [titleLabel setText:titleStr];
    UILabel *updateLabel = (UILabel *)[cell.contentView viewWithTag:PRMTableUpdateLabel];
    [updateLabel setText:self.dataManager.updates[indexPath.row]];
    UILabel *themeLabel = (UILabel *)[cell.contentView viewWithTag:PRMTableThemeLabel];
    [themeLabel setText:self.dataManager.themes[indexPath.row]];
    UIButton *favoriteButton = (UIButton *)[cell.contentView viewWithTag:PRMTableFavoriteButton];
    if ([self.dataManager.isFavorite[indexPath.row] boolValue]) {
        [favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    else {
        [favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite_off"] forState:UIControlStateNormal];
    }
    
    UIImageView *thumbnailImageView = (UIImageView *)[cell.contentView viewWithTag:PRMTableImageView];
    
    if([self.dataManager.themes[indexPath.row] isEqualToString:@"ハルカ日記"] || [self.dataManager.themes[indexPath.row] isEqualToString:@"HARUKAブログ"]){
        [thumbnailImageView setImage:[UIImage imageNamed:@"haru"]];
    }
    else if([self.dataManager.themes[indexPath.row] isEqualToString:@"フミカ日記"] || [self.dataManager.themes[indexPath.row] isEqualToString:@"FUMIKAブログ"]){
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

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height){
        if(self.isFetch == NO){
            [self fetchData:self.maxPageNum+1 maxPageNum:self.maxPageNum+10];
        }
    }
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark EGORefreshTableHeaderDelegate Methods


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark - EGORefreshTableHeaderDelegate


// TODO: 引っ張って更新時に呼び出される
- (void)tableViewPullToRefresh{
    if(self.isFetch == NO){
        [self fetchDataUpdate];
    }
    
}


- (void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    self.reloading = YES;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        // 0.5秒Wait(連続更新されるのを防ぐため)
        [NSThread sleepForTimeInterval:0.5];
        [self tableViewPullToRefresh];
        // メインスレッドで更新完了処理
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.reloading = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }];
    }];
    
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}



- (void)fetchDataUpdate{
    self.isFetch = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:PRMBaseUrl]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRMBlogDataManager *latestManager = [PRMBlogDataManager new];
        
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithData:responseObject error:&error];
        HTMLNode *bodyNode = [parser body];
        NSArray *aNodes = [bodyNode findChildTags:@"a"];
        for (HTMLNode *node in aNodes) {
            if([[node getAttributeNamed:@"class"] isEqualToString:@"skinArticleTitle"]){
                [latestManager addTitlesObject:[node contents]];
                [latestManager addArticleUrlsObject:[node getAttributeNamed:@"href"]];
                [latestManager addIsFavorite:[self checkIsFavorite:[node getAttributeNamed:@"href"]]];
            }
            if([[node getAttributeNamed:@"rel"] isEqualToString:@"tag"]){
                [latestManager addThemesObject:[node contents]];
            }
        }
        NSArray *times = [bodyNode findChildTags:@"time"];
        for (HTMLNode *node in times){
            [latestManager addUpdatesObject:[node getAttributeNamed:@"datetime"]];
        }
        
        //取得したデータが最新かどうかを判断
        NSInteger updateCount = 0;
        for(NSInteger count = 0; count < [latestManager count] ; count++){
            // 更新があれば
            if([latestManager.titles[count] isEqualToString:self.dataManager.titles[0]] == NO){
                updateCount++;
            }
            else{
                break;
            }
        }
        
        if(updateCount){
            //情報を挿入
            for(NSInteger count = updateCount-1; count >= 0;count--){
                [self.dataManager insertTitlesObject:latestManager.titles[count]];
                [self.dataManager insertArticleUrlsObject:latestManager.articleUrls[count]];
                [self.dataManager insertThemesObject:latestManager.themes[count]];
                [self.dataManager insertUpdatesObject:latestManager.updates[count]];
                [self.dataManager insertIsFavorite:[latestManager.isFavorite[count] boolValue]];
            }
            
            [self.tableView reloadData];
        }
        self.isFetch = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isFetch = NO;
        NSLog(@"%@", error.localizedDescription);
    }];
    [operation start];
}

- (void)reloadTableView
{
    NSMutableArray* articles = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    //お気に入りを更新
    for (int i=0; i < [self.dataManager.articleUrls count]; i++) {
        Boolean isFind = NO;
        for (NSString* article in articles) {
            if ([article isEqualToString:self.dataManager.articleUrls[i]]) {
                self.dataManager.isFavorite[i] = @(YES);
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            self.dataManager.isFavorite[i] = @(NO);
        }
    }
    [self.tableView reloadData];
}


-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController: (UIViewController*)viewController{
    
    switch (tabBarController.selectedIndex) {
        case 0:
            [self reloadTableView];
            break;
        default:
            break;
    }
}

- (IBAction)favoriteButtonTouched:(UIButton *)sender event:(id)event{
    //タッチしたセルを検索
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSInteger index = [self.tableView indexPathForRowAtPoint: currentTouchPosition].row;
    
    //お気に入りボタンを切替
    Boolean isFavorite = ![self.dataManager.isFavorite[index] boolValue];
    if (isFavorite) {
        [sender setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    else {
        [sender setBackgroundImage:[UIImage imageNamed:@"favorite_off"] forState:UIControlStateNormal];
    }
    [self.dataManager updateIsFavorite:isFavorite index:index];
    
    NSMutableArray* favoriteArticles = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    NSMutableArray* favoriteTitles   = [[PRMAppDefaults currentDefaults] favoriteBlogTitles];
    NSMutableArray* favoriteThemes   = [[PRMAppDefaults currentDefaults] favoriteBlogThemes];
    NSMutableArray* favoriteUpdates  = [[PRMAppDefaults currentDefaults] favoriteBlogUpdates];
    
    if (isFavorite) {
        [favoriteArticles addObject:self.dataManager.articleUrls[index]];
        [favoriteThemes addObject:self.dataManager.themes[index]];
        [favoriteTitles addObject:self.dataManager.titles[index]];
        [favoriteUpdates addObject:self.dataManager.updates[index]];
    }
    else {
        for (int i=0; i<[favoriteArticles count]; i++) {
            if ([favoriteArticles[i] isEqualToString:self.dataManager.articleUrls[index]]) {
                [favoriteArticles removeObjectAtIndex:index];
                [favoriteThemes removeObjectAtIndex:index];
                [favoriteTitles removeObjectAtIndex:index];
                [favoriteUpdates removeObjectAtIndex:index];
                
                break;
            }
        }
    }
    
    [[PRMAppDefaults currentDefaults] setFavoriteBlogArticleUrls:favoriteArticles];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogThemes:favoriteThemes];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogTitles:favoriteTitles];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogUpdates:favoriteUpdates];
}

- (Boolean)checkIsFavorite:(NSString *)articleUrl
{
    NSMutableArray* array = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    for (NSString* favoriteArticleUrl in array) {
        if ([favoriteArticleUrl isEqualToString:articleUrl]) {
            return YES;
        }
    }
    return NO;
}


@end
