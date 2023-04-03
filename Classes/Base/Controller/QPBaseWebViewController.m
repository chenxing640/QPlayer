//
//  QPBaseWebViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"

@interface QPBaseWebViewController ()
@property (nonatomic, strong) WKWebView *wkWebView; // Declares a web view object.
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKUserContentController *userContentController;
@end

@implementation QPBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (WKWebView *)webView {
    return self.wkWebView;
}

- (void)releaseWebView
{
    if (self.wkWebView) {
        self.wkWebView = nil;
    }
}

- (WKWebViewConfiguration *)webViewConfiguration
{
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.minimumFontSize = 0;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webViewConfiguration.preferences = preferences;
        //_webViewConfiguration.processPool = [[WKProcessPool alloc] init];
        _webViewConfiguration.userContentController = self.userContentController;
        _webViewConfiguration.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            // The default value is YES.
            _webViewConfiguration.allowsAirPlayForMediaPlayback = YES;
            _webViewConfiguration.allowsPictureInPictureMediaPlayback = YES;
            if (@available(iOS 10.0, *)) {
                // WKAudiovisualMediaTypeNone
                _webViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
            } else {
                //_webViewConfiguration.requiresUserActionForMediaPlayback = NO;
            }
        } else {
            // Fallback on earlier versions
            //_webViewConfiguration.mediaPlaybackAllowsAirPlay = YES;
            //_webViewConfiguration.mediaPlaybackRequiresUserAction = YES;
        }
    }
    return _webViewConfiguration;
}

- (WKUserContentController *)userContentController
{
    if (!_userContentController) {
        _userContentController = WKUserContentController.alloc.init;
    }
    return _userContentController;
}

- (void)initWebViewWithFrame:(CGRect)frame
{
    [self initWebViewWithFrame:frame configuration:self.webViewConfiguration];
}

- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    [self initWebViewWithFrame:frame configuration:configuration adapter:nil];
}

- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration adapter:(QPWKWebViewAdapter *)adapter
{
    _adapter = adapter;
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        _wkWebView.UIDelegate = _adapter;
        _wkWebView.navigationDelegate = _adapter;
    }
}

- (void)setAdapter:(QPWKWebViewAdapter *)adapter
{
    _adapter = adapter;
    _wkWebView.UIDelegate = _adapter;
    _wkWebView.navigationDelegate = _adapter;
}

- (void)loadRequestWithUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadRequest:(NSURLRequest *)urlRequest
{
    [self.webView loadRequest:urlRequest];
}

- (void)onGoBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)onGoForward
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)onReload
{
    [_adapter hideProgressViewImmediately];
    [self.webView reload];
}

- (void)onStopLoading
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}

- (UIImageView *)buildToolBar
{
    return [self buildToolBar:@selector(tbItemClicked:)];
}

- (UIImageView *)buildToolBar:(SEL)selector
{
    return [self buildAndLayoutToolBar:selector isVertical:NO];
}

- (UIImageView *)buildVerticalToolBar
{
    return [self buildVerticalToolBar:@selector(tbItemClicked:)];
}

- (UIImageView *)buildVerticalToolBar:(SEL)selector
{
    return [self buildAndLayoutToolBar:selector isVertical:YES];
}

- (UIImageView *)buildAndLayoutToolBar:(SEL)selector isVertical:(BOOL)isVertical
{
    NSMutableArray *items = @[@"web_reward_13x21", @"web_forward_13x21",
                              @"web_refresh_24x21", @"web_stop_21x21",
                              @"parse_button_blue"].mutableCopy;
    if (!self.parsingRequired) { [items removeLastObject]; }
    BOOL bVal;
    if (isVertical) {
        bVal = self.parsingRequired || !self.hidesBottomBarWhenPushed;
    } else {
        bVal = !self.hidesBottomBarWhenPushed;
    }
    
    NSUInteger count = items.count;
    CGFloat hSpace   = 10.f;
    CGFloat vSpace   = isVertical ? 5.f : 8.f;
    CGFloat btnW     = 30.f;
    CGFloat btnH     = 30.f;
    CGFloat offset   = bVal ? QPTabBarHeight : (QPIsPhoneXAll ? 4 : 2)*vSpace;
    CGFloat tlbW     = btnW + 2*hSpace;
    CGFloat tlbH     = count*btnH + (count+1)*vSpace + 4*vSpace;
    CGFloat tlbX     = QPScreenWidth - tlbW - hSpace;
    CGFloat tlbY     = self.view.height - offset - tlbH - 2*vSpace;
    CGRect  tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
    
    if (!isVertical) {
        tlbX = 1.5*hSpace;
        tlbW = self.view.width - 2*tlbX;
        tlbH = btnH + 3*vSpace;
        tlbY = self.view.height - offset - tlbH - (bVal ? 2*vSpace : 0) + 5.f;
        tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
        btnW = (tlbW - (count+1)*hSpace)/count;
    }
    
    UIImageView *toolBar    = [[UIImageView alloc] initWithFrame:tlbFrame];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.image           = [self colorImage:toolBar.bounds
                                  cornerRadius:15.f
                                backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                   borderWidth:0.f
                                   borderColor:nil];
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isVertical) {
            button.frame = CGRectMake(hSpace, (i+1)*vSpace+i*btnH, btnW, btnH);
        } else {
            button.frame = CGRectMake((i+1)*vSpace+i*btnW, 1.5*vSpace, btnW, btnH);
        }
        button.tag = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:QPImageNamed(items[i]) forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
    }
    toolBar.userInteractionEnabled = YES;
    [toolBar autoresizing];
    
    return toolBar;
}

- (void)tbItemClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 100;
    switch (index) {
        case 0: [self onGoBack]; break;
        case 1: [self onGoForward]; break;
        case 2: [self onReload]; break;
        case 3: [self onStopLoading]; break;
        case 4: QPLog("::"); break;
        default: break;
    }
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self.adapter setIsDarkMode:self.isDarkMode];
}

- (void)dealloc
{
    QPLog(@"::");
    [self.userContentController removeAllUserScripts];
    if (@available(iOS 14.0, *)) {
        [self.userContentController removeAllScriptMessageHandlers];
    } else {
        // Unknow
        //[self.userContentController removeScriptMessageHandlerForName:@""];
    }
    [self releaseWebView];
    [self removeThemeStyleChangedObserver];
}

@end