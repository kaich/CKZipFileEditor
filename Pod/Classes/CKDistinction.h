//
//  CKDistinction.h
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKDistinction : NSObject

@property(nonatomic,strong) NSString * content;
@property(nonatomic,assign) long long offset;
-(instancetype) initWithDictionary:(NSDictionary *) jsonObject;

@end
