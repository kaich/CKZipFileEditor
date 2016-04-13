//
//  CKViewController.m
//  CKZipFileEditor
//
//  Created by kaich on 03/18/2016.
//  Copyright (c) 2016 kaich. All rights reserved.
//

#import "CKViewController.h"
#import "CKZipFileEditor.h"
#import "CKZipFileEditor+IPA.h"
#import "CKDistinction.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:@"http://192.168.1.126:3000/app/origin/get_sign_information"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError * parseError = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        long long fileSize = [jsonObject[@"totalsize"] integerValue];
        NSMutableArray * distinctions = [NSMutableArray array];
        for (NSDictionary * emDic in jsonObject[@"distinctions"]) {
            CKDistinction *distinction = [[CKDistinction alloc] initWithDictionary:emDic];
            [distinctions addObject:distinction];
        }
        if(!parseError)
        {
            NSLog(@"------------replace begin");
            NSString * zipPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/origin.ipa"];
            CKZipFileEditor * editor = [[CKZipFileEditor alloc] init];
            [editor replaceZipFile:zipPath fileFilter:^BOOL(NSString *fileName) {
                return [CKZipFileEditor isExecutableFile:fileName];
            } fileSize:fileSize distinctions:distinctions];
            NSLog(@"++++++++++++replace complate");
        }
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
