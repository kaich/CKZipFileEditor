//
//  CKViewController.m
//  CKZipFileEditor
//
//  Created by kaich on 03/18/2016.
//  Copyright (c) 2016 kaich. All rights reserved.
//

#import "CKViewController.h"
#import "CKZipFileEditor.h"
#import "CKDistinction.h"
#import "CKFileInfo.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL * url = [NSURL URLWithString:@"http://192.168.1.130:3000/app/origin/get_sign_information"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError * parseError = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        
        NSMutableArray<CKFileProtocol> * distinctFiles = (NSMutableArray<CKFileProtocol> *)[NSMutableArray array];
        for (NSDictionary * emDic in jsonObject) {
            
            CKFileInfo * fileInfo = [[CKFileInfo alloc] initWithDictionary:emDic];
            [distinctFiles addObject:fileInfo];
        }
        
        if(!parseError)
        {
            NSLog(@"------------replace begin");
            NSString * zipPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/origin.ipa"];
            CKZipFileEditor * editor = [[CKZipFileEditor alloc] init];
            editor.tempFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            [editor replaceZipFile:zipPath fileDistinctions:distinctFiles];
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
