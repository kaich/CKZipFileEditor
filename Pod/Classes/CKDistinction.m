//
//  CKDistinction.m
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import "CKDistinction.h"

@implementation CKDistinction

-(instancetype) initWithDictionary:(NSDictionary *) jsonObject
{
    self = [super init];
    if(self)
    {
        self.content = jsonObject[@"content"];
        self.offset = [jsonObject[@"frome_offset"] longLongValue];
    }
    return self;
}

@end
