//
//  SWCallSetting.m
//  swig
//
//  Created by Pierre-Marc Airoldi on 2014-08-18.
//  Copyright (c) 2014 PeteAppDesigns. All rights reserved.
//

#import "SWCallSetting.h"

@implementation SWCallSetting

-(instancetype)init {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    pj::CallSetting callSetting(true);
    _flag = callSetting.flag;
    _reqKeyframeMethod = callSetting.reqKeyframeMethod;
    _audioCount = callSetting.audioCount;
    _videoCount = callSetting.videoCount;
    
    return self;
}

+(instancetype)defaultSettings {
    
    return [[SWCallSetting alloc] init];
}

-(pj::CallSetting)callSetting {

    pj::CallSetting callSetting(true);
    callSetting.flag = self.flag;
    callSetting.reqKeyframeMethod = self.reqKeyframeMethod;
    callSetting.audioCount = self.audioCount;
    callSetting.videoCount = self.videoCount;

    return callSetting;
}


@end
