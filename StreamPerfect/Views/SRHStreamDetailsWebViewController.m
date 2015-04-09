//
//  SRHStreamDetailsWebViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-26.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamDetailsWebViewController.h"
#import "SRHStream.h"
#import "SRHStreamer.h"

#import <Masonry/Masonry.h>

@interface SRHStreamDetailsWebViewController () <UIWebViewDelegate>

@property(nonatomic, weak) SRHStream *stream;
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation SRHStreamDetailsWebViewController

- (instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stream = stream;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview);
    }];
    
    [self setupWebView];
}

- (void)setupWebView {
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TwitchContainer" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%streamerName%%" withString:self.stream.streamer.name];
    
    NSURL *imagePath  = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"png"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%backgroundName%%" withString:[imagePath absoluteString]];
    
    self.webView.mediaPlaybackRequiresUserAction = NO;
    self.webView.delegate = self;
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Public

- (void)killStream {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

#pragma mark - UIWebView delegate

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    //TODO : Check to see if this really works
//    if ([[request.URL absoluteString] rangeOfString:@"pubads"].location != NSNotFound) {
//        return NO;
//    } else if ([[request.URL absoluteString] rangeOfString:@"adserver"].location != NSNotFound) {
//        return NO;
//    }
//    
//    NSLog(@"Request: %@", [request description]);
//    
//    return YES;
//}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"Web view did start load");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"Web view did finish load");
//}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web view error: %@", [error description]);
}

@end
