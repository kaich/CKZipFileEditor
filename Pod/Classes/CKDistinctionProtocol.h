//
//  CKDistinction.h
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKDistinctionProtocol<NSObject>

@property(nonatomic,strong) NSData * data;
@property(nonatomic,assign) long long offset;

@end
