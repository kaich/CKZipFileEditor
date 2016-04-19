//
//  LargeZipFileEditor.m
//  EditBigFile
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 kaicheng. All rights reserved.
//

#import "CKZipFileEditor.h"
#import "NSString+MD5.h"
#import "objective-zip/Objective-Zip.h"


@implementation CKZipFileEditor


-(void) replaceZipFile:(NSString *) zipPath  fileDistinctions:(NSArray<CKFileProtocol>  *) distinctFiles
{
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:zipPath], @"zip file does not exist at path!");
    
    const char * replaced_file = NULL;
    
    char * buf = NULL;
    int  buf_size = 1024;
    
    OZZipFile * zip = [[OZZipFile alloc] initWithFileName:zipPath mode:OZZipFileModeUnzip];
    
    if(zip)
    {
        NSString * fileName = nil;
        unsigned long long fileLength = 0;
        
        for(id<CKFileProtocol>  emDistinctFile in distinctFiles)
        {
            [zip locateFileInZip:emDistinctFile.filename];
            OZFileInZipInfo * emfile = [zip getCurrentFileInZipInfo];
            
            fileName = emfile.name;
            fileLength = emfile.length;
            
            NSArray * distinctions = emDistinctFile.distinctions;
            if(distinctions)
            {
                [zip locateFileInZip:fileName];
                
                OZZipReadStream * readStream =  [zip readCurrentFileInZip];
                
                replaced_file = [[self replaceFilePath:zipPath filename:fileName] cStringUsingEncoding:NSUTF8StringEncoding];
                
                long long sum = 0;
                NSUInteger len ;
                FILE * fd = fopen(replaced_file, "w");
                NSMutableData * data = [NSMutableData dataWithCapacity:buf_size];
                while (sum != fileLength) {
                    [data setLength:buf_size];
                    len = [readStream readDataWithBuffer:data];
                    buf = (char *)[data bytes];
                    fwrite(buf, sizeof(char), (size_t)len, fd);
                    sum += len;
                }
                fclose(fd);
                [readStream finishedReading];
                
                
                [self replaceFile:[NSString stringWithCString:replaced_file encoding:NSUTF8StringEncoding] distinctions:distinctions fileSize:emDistinctFile.fileSize];
                
            }
        }
        
        
        [zip close];
    }
    
    
    
    OZZipFile * azip = [[OZZipFile alloc] initWithFileName:zipPath mode:OZZipFileModeAppend];
    
    if(azip)
    {
        for (id<CKFileProtocol>  emDistinctFile in distinctFiles) {
            OZZipWriteStream * writeStream = [azip writeFileInZipWithName:emDistinctFile.filename fileDate:[NSDate date] compressionLevel:OZZipCompressionLevelDefault];
            FILE * rf = fopen(replaced_file, "r");
            size_t wlen = 0;
            size_t total = 0;
            NSData * data = nil;
            while ((wlen = fread(buf, sizeof(char), buf_size, rf)) > 0) {
                data = [NSData dataWithBytes:buf length:wlen];
                [writeStream writeData:data];
                total += wlen;
            }
            fclose(rf);
            [writeStream finishedWriting];
        }
        
        
        [azip close];
        
    }
    
    [self deleteTempFile:zipPath];
    
}


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
        NSData * contentData = emDistinction.data;
        
        [handle seekToFileOffset:frome_offset];
        [handle writeData:contentData];
        
    }
    [handle truncateFileAtOffset:fileSize];
    [handle closeFile];
}

-(NSString *) tempDirectory:(NSString *) zipPath
{
    NSString * tempFileBaseDir = self.tempFilePath ?  self.tempFilePath : NSTemporaryDirectory();
    NSString * name = [[zipPath stringByDeletingPathExtension] lastPathComponent];
    NSString * tempFileDir = [tempFileBaseDir stringByAppendingPathComponent:name];
    [self createFolder:tempFileDir];
    return tempFileDir;
}

-(NSString *) replaceFilePath:(NSString *) zipPath filename:(NSString *) filename
{
    NSString * tempFileDir = [self tempDirectory:zipPath];
    
    NSString * filenameMD5 = [filename MD5Digest];
    NSString * replacedExecutableFile = [tempFileDir stringByAppendingPathComponent:filenameMD5];
    return replacedExecutableFile;
}

-(void) deleteTempFile:(NSString *) zipPath
{
    NSString * tempPath = [self tempDirectory:zipPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:tempPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    }
}

-(BOOL) createFolder:(NSString*) path {
    NSFileManager *filemgr = [NSFileManager new];
    
    NSError *error = nil;
    if (![filemgr fileExistsAtPath:path]) {
        [filemgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if(error)
    {
        NSLog(@"Failed to create cache directory");
        return NO;
    }
    return  YES;
}

@end
