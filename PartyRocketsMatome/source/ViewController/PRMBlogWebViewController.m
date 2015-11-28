//
//  PRMBlogWebViewController.m
//  PartyRocketsMatome
//
//  Created by 川口功 on 2014/09/06.
//  Copyright (c) 2014年 I.K. All rights reserved.
//

#import "PRMBlogWebViewController.h"
#import "UIViewController+NJKFullScreenSupport.h"


@interface PRMBlogWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;
@property (nonatomic) NJKScrollFullScreen *fullScreen;

@end

@implementation PRMBlogWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //URLを読み込み
    NSURLRequest *request;
    
    //指定URLがなければAmazonを、あればそのURLを開く
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[PRMAppDefaults currentDefaults] blogOpenUrl]]];
    [self.navigationItem setTitle:[[PRMAppDefaults currentDefaults] blogOpenTitle]];
    [self.ibWebView loadRequest:request];
    
    
    self.fullScreen = [[NJKScrollFullScreen alloc] initWithForwardTarget:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    self.ibWebView.scrollView.delegate = (id)self.fullScreen; // cast for surpress incompatible warnings
    self.fullScreen.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self showNavigationBar:YES];
    [self showTabBar:YES];
}

// TODO: ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// TODO: ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
}



@end
