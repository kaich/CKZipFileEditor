//
//  LargeZipFileEditor.m
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import "CKZipFileEditor.h"
#include "libzip_iOS/zip.h"
//#import "objective-zip/Objective-Zip.h"


@implementation CKZipFileEditor


-(void) replaceZipFile:(NSString *) zipPath fileFilter:(CKZipFileFilterBlock) filterBlock  fileSize:(long long) fileSize distinctions:(NSArray *) distinctions
{
    NSAssert(filterBlock, @"");
    
    const char * replaced_excutable_file = [[self replaceFilePath:zipPath] cStringUsingEncoding:NSUTF8StringEncoding];
    
    const char * zip_path = [zipPath cStringUsingEncoding:NSUTF8StringEncoding];
    
    struct zip * zip = zip_open(zip_path, ZIP_CREATE, NULL);
    if(zip)
    {
        char buf[1024];
        int  buf_size = 1024;
        zip_int64_t entiry_count = zip_get_num_entries(zip, 0);
        for(zip_int64_t i = 0 ; i < entiry_count ; i ++)
        {
            struct zip_stat  sta;
            zip_stat_init(&sta);
            zip_stat_index(zip, i, 0, &sta);
            
            NSString * fileName = [NSString stringWithCString:sta.name encoding:NSUTF8StringEncoding];
            if(filterBlock(fileName))
            {
                
                struct zip_file * zf = zip_fopen(zip, sta.name, ZIP_FL_ENC_UTF_8);
                long long sum = 0;
                zip_int64_t len ;
                FILE * fd = fopen(replaced_excutable_file, "w");
                while (sum != sta.size) {
                    len = zip_fread(zf, buf, buf_size);
                    if (len < 0) {
                        fprintf(stderr, "boese, boese/n");
                        exit(102);
                    }
                    fwrite(buf, sizeof(char), (size_t)len, fd);
                    sum += len;
                }
                fclose(fd);
                zip_fclose(zf);
                
                [self replaceFile:[NSString stringWithCString:replaced_excutable_file encoding:NSUTF8StringEncoding] distinctions:distinctions fileSize:fileSize];
                
                
                FILE * replace_file = fopen(replaced_excutable_file, "r");
                struct zip_source * replaced_source = zip_source_filep(zip,replace_file, 0, -1);
                
                if(replaced_source)
                {
                    zip_file_replace(zip, i, replaced_source, 0);
                    zip_source_free(replaced_source);
                }
                
                [self deleteTempFile:zipPath];
            }
        }
    }
    
    zip_close(zip);
}

//-(void) replaceZipFile:(NSString *) zipPath fileFilter:(CKZipFileFilterBlock) filterBlock  fileSize:(long long) fileSize distinctions:(NSArray *) distinctions
//{
//    NSAssert(filterBlock, @"");
//    
//    const char * replaced_excutable_file = [[self replaceFilePath:zipPath] cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString * fileName = nil;
//    NSUInteger fileLength = 0;
//    
//    char * buf;
//    int  buf_size = 1024;
//    
//    OZZipFile * zip = [[OZZipFile alloc] initWithFileName:zipPath mode:OZZipFileModeUnzip];
//    
//    if(zip)
//    {
//        
//        for(OZFileInZipInfo * emfile in zip.listFileInZipInfos)
//        {
//            
//            fileName = emfile.name;
//            fileLength = emfile.length;
//            
//            
//            if(filterBlock(fileName))
//            {
//                [zip locateFileInZip:fileName];
//                
//                OZZipReadStream * readStream =  [zip readCurrentFileInZip];
//                
//                long long sum = 0;
//                NSUInteger len ;
//                FILE * fd = fopen(replaced_excutable_file, "w");
//                NSMutableData * data = [NSMutableData dataWithCapacity:buf_size];
//                while (sum != fileLength) {
//                    [data setLength:buf_size];
//                    len = [readStream readDataWithBuffer:data];
//                    buf = (char *)[data bytes];
//                    fwrite(buf, sizeof(char), (size_t)len, fd);
//                    sum += len;
//                }
//                fclose(fd);
//                [readStream finishedReading];
//                
//                [zip close];
//                
//                
//                break;
//            }
//        }
//    }
//    
//    
//    [self replaceFile:[NSString stringWithCString:replaced_excutable_file encoding:NSUTF8StringEncoding] distinctions:distinctions fileSize:fileSize];
//                
//    
//    OZZipFile * azip = [[OZZipFile alloc] initWithFileName:zipPath mode:OZZipFileModeAppend];
//    
//    if(azip)
//    {
//        OZZipWriteStream * writeStream = [azip writeFileInZipWithName:fileName fileDate:[NSDate date] compressionLevel:OZZipCompressionLevelNone];
//        FILE * rf = fopen(replaced_excutable_file, "r");
//        size_t wlen = 0;
//        size_t total = 0;
//        while ((wlen = fread(buf, sizeof(char), buf_size, rf)) > 0) {
//            NSData * data = [NSData dataWithBytes:buf length:wlen];
//            [writeStream writeData:data];
//            total += wlen;
//        }
//        fclose(rf);
//        [writeStream finishedWriting];
//        [azip close];
//    }
//    
//    [self deleteTempFile:zipPath];
//    
//    
//}


#pragma mark - private method 

-(void) replaceFile:(NSString *) path distinctions:(NSArray *) distinctions fileSize:(long long) fileSize
{
    NSFileHandle * handle = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        handle = [NSFileHandle fileHandleForWritingAtPath: path];
    }
    
    for (id<CKDistinctionProtocol> emDistinction in distinctions) {
        long long frome_offset = emDistinction.offset;
        NSString * content = emDistinction.content;
        NSData * contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        [handle seekToFileOffset:frome_offset];
        [handle writeData:contentData];
        
    }
    [handle truncateFileAtOffset:fileSize];
    [handle closeFile];
}

-(NSString *) replaceFilePath:(NSString *) zipPath
{
    NSString * tempFileDir = self.tempFilePath ?  self.tempFilePath : NSTemporaryDirectory();
    NSString * name = [[zipPath stringByDeletingPathExtension] lastPathComponent];
    NSString * replacedExecutableFile = [tempFileDir stringByAppendingPathComponent:name];
    return replacedExecutableFile;
}

-(void) deleteTempFile:(NSString *) zipPath
{
    NSString * tempPath = [self replaceFilePath: zipPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    }
}

@end
