//
//  ViewController.m
//  J2MObject
//
//  Created by Limboy on 8/4/13.
//  Copyright (c) 2013 Limboy. All rights reserved.
//

#import "ViewController.h"
#import "NewsItem.h"
#import "News.h"

#define JSON_URL @"http://news.at.zhihu.com/api/1.1/news/latest"

@interface ViewController ()
@property (nonatomic) NSMutableData *urlData;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.urlData = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JSON_URL]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *jsonParsingError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self.urlData options:0 error:&jsonParsingError];
    
    if (jsonParsingError) {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    } else {
        [self parseResult:object];
    }
}

- (void)parseResult:(NSDictionary *)JSON
{
    // after we got the json data, parse is really easy
    for (NSDictionary *dict in JSON[@"news"]) {
        News *news = [[News alloc] initWithDictionary:dict];
        NSLog(@"news.title:%@", news.title);
        NSLog(@"news.gaPrefix:%@", news.gaPrefix);
        NSLog(@"news.items:%@", news.items);
//        for (NewsItem *newsItem in news.items) {
//            NSLog(@"newsItems.imageSource:%@", newsItem.imageSource);
//        }
    }
}
@end
