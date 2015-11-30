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

@property (nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

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
    
    // 引っ張って更新の初期化
    // 更新ビューのサイズとデリゲートを指定する
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,  - self.tableView.bounds.size.height + PRMTableHeight, self.view.frame.size.width, self.tableView.bounds.size.height - PRMTableHeight)];
    self.refreshHeaderView.delegate = self;
    [self.tableView addSubview:self.refreshHeaderView];

    //  update the last update date
    [self.refreshHeaderView refreshLastUpdatedDate];
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

- (void)reloadTableView
{
    //データ更新
    self.dataManager.articleUrls = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    self.dataManager.titles = [[PRMAppDefaults currentDefaults] favoriteBlogTitles];
    self.dataManager.themes = [[PRMAppDefaults currentDefaults] favoriteBlogThemes];
    self.dataManager.updates = [[PRMAppDefaults currentDefaults] favoriteBlogUpdates];
    [self.tableView reloadData];
}


#pragma mark - EGORefreshTableHeaderDelegate


- (void) egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    self.reloading = YES;
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        // 0.5秒Wait(連続更新されるのを防ぐため)
        [NSThread sleepForTimeInterval:0.5];
        
        [self reloadTableView];
        
        // メインスレッドで更新完了処理
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.reloading = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }];
    }];
    
}

- (IBAction)favoriteButtonTouched:(UIButton *)sender event:(id)event{
    //タッチしたセルを検索
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSInteger index = [self.tableView indexPathForRowAtPoint: currentTouchPosition].row;
    
    NSMutableArray* favoriteArticles = [[PRMAppDefaults currentDefaults] favoriteBlogArticleUrls];
    NSMutableArray* favoriteTitles   = [[PRMAppDefaults currentDefaults] favoriteBlogTitles];
    NSMutableArray* favoriteThemes   = [[PRMAppDefaults currentDefaults] favoriteBlogThemes];
    NSMutableArray* favoriteUpdates  = [[PRMAppDefaults currentDefaults] favoriteBlogUpdates];
    
    for (int i=0; i<[favoriteArticles count]; i++) {
        if ([favoriteArticles[i] isEqualToString:self.dataManager.articleUrls[index]]) {
            [favoriteArticles removeObjectAtIndex:index];
            [favoriteThemes removeObjectAtIndex:index];
            [favoriteTitles removeObjectAtIndex:index];
            [favoriteUpdates removeObjectAtIndex:index];
            
            break;
        }
    }
    [[PRMAppDefaults currentDefaults] setFavoriteBlogArticleUrls:favoriteArticles];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogThemes:favoriteThemes];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogTitles:favoriteTitles];
    [[PRMAppDefaults currentDefaults] setFavoriteBlogUpdates:favoriteUpdates];
    
    [self reloadTableView];
}

@end
