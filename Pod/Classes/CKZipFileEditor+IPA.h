//
//  NSObject+IPA.h
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKZipFileEditor.h"

@interface CKZipFileEditor (IPA)

+(BOOL) isExecutableFile:(NSString *) filePath;

@end
