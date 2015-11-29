//
//  PRTBlogTableViewController.h
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGOTableViewPullRefreshAndLoadMore/EGORefreshTableHeaderView.h>

@interface PRMFavoriteTableViewController : UITableViewController<EGORefreshTableHeaderDelegate>

- (void)reloadTableView;

@end
