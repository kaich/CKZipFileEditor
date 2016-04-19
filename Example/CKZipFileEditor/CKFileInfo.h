//
//  CKFileInfo.h
//  CKZipFileEditor
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 kaich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKFileProtocol.h"
#import "CKDistinctionProtocol.h"
#import "CKDistinction.h"

@interface CKFileInfo : NSObject<CKFileProtocol>
@property(nonatomic,strong) NSString * filename;
@property(nonatomic,assign) long long fileSize;
@property(nonatomic,strong) NSArray<CKDistinctionProtocol> * distinctions;
-(instancetype) initWithDictionary:(NSDictionary *) jsonObject;
@end
