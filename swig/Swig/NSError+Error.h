//
//  NSError+Error.h
//  swig
//
//  Created by Pierre-Marc Airoldi on 2014-08-14.
//  Copyright (c) 2014 PeteAppDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Error)

+(NSError *)errorFromError:(NSValue *)value;

@end