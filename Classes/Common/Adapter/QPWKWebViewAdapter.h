//
//  QPWKWebViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QPBaseDelegate.h"
#import "DYFWebProgressView.h"
#import "QPBaseAdapter.h"

typedef void(^ObserveUrlLinkBlock)(NSString *url);

@protocol QPWKWebViewAdapterDelegate <QPBaseDelegate>

@end

@interface QPWKWebViewAdapter : QPBaseWebAdapter <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL isDarkMode;
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UINavigationBar *navigationBar;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, copy, readonly) NSString *urlLink;

- (instancetype)initWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar;
- (instancetype)initWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar toolBar:(UIView *)toolBar;

/// Inspects the alpha of tool bar.
- (void)inspectToolBarAlpha;

/// Returns Wether a progress bar is added to the navigation bar.
- (BOOL)isAddedToNavBar;

/// Adds a progress view to a web view.
- (void)addProgressViewToWebView;
/// Adds a progress view to a navigation bar.
- (void)addProgressViewToNavigationBar;

/// Gets a web progress view.
- (DYFProgressView *)progressView;
/// Shows a web progress view.
- (void)showProgressView;
/// Hides a web progress view.
- (void)hideProgressView;
/// Hides a web progress view immediately.
- (void)hideProgressViewImmediately;

/// Observes the current url link.
- (void)observeUrlLink:(ObserveUrlLinkBlock)block;

@end
