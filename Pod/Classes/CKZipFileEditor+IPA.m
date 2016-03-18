//
//  NSObject+IPA.m
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import "CKZipFileEditor+IPA.h"

@implementation CKZipFileEditor (IPA)


+(BOOL) isExecutableFile:(NSString *) filePath
{
    NSArray * components = [filePath componentsSeparatedByString:@"/"];
    
    NSString * fileName = components.lastObject;
    NSString * appName = [components[1] stringByDeletingPathExtension];
    
    if(components.count == 3 && [fileName isEqualToString: appName])
    {
        return  YES;
    }
    
    return  NO;
}

@end
