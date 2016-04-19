//
//  NSObject+CKFileInformationProtocol.h
//  Pods
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKDistinctionProtocol.h"

@protocol CKFileProtocol <NSObject>

@property(nonatomic,strong) NSString * filename;
@property(nonatomic,assign) long long fileSize;
@property(nonatomic,strong) NSArray<CKDistinctionProtocol> * distinctions;

@end
