//
//  DDFileReader.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

//DDFileReader.h
#import <Foundation/Foundation.h>

@interface DDFileReader : NSObject {
  NSString * filePath;
  
  NSFileHandle * fileHandle;
  unsigned long long currentOffset;
  unsigned long long totalFileLength;
  
  NSString * lineDelimiter;
  NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end
