//
//  LargeZipFileEditor.h
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKDistinctionProtocol.h"

typedef BOOL(^CKZipFileFilterBlock)(NSString * fileName);

@interface CKZipFileEditor : NSObject
@property(nonatomic,strong) NSString * tempFilePath;

-(void) replaceZipFile:(NSString *) zipPath fileFilter:(CKZipFileFilterBlock) filterBlock  fileSize:(long long) fileSize distinctions:(NSArray *) distinctions;

@end
