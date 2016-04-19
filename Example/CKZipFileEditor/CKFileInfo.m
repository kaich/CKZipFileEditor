//
//  CKFileInfo.m
//  CKZipFileEditor
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 kaich. All rights reserved.
//

#import "CKFileInfo.h"

@implementation CKFileInfo


-(instancetype) initWithDictionary:(NSDictionary *) jsonObject
{
    self = [super init];
    if(self)
    {
        self.filename = jsonObject[@"file_name"];
        self.fileSize = [jsonObject[@"file_size"] longLongValue];
        
        NSMutableArray * mdistinctions = [NSMutableArray array];
        for (NSDictionary * emDic in jsonObject[@"distinctions"]) {
            CKDistinction *distinction = [[CKDistinction alloc] initWithDictionary:emDic];
            [mdistinctions addObject:distinction];
        }
        self.distinctions = [mdistinctions copy];
    }
    return self;
}

@end
