//
//  CKDistinction.h
//  CKZipFileEditor
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 kaich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKDistinctionProtocol.h"

@interface CKDistinction : NSObject<CKDistinctionProtocol>

@property(nonatomic,strong) NSData * data;
@property(nonatomic,assign) long long offset;
-(instancetype) initWithDictionary:(NSDictionary *) jsonObject;

@end
