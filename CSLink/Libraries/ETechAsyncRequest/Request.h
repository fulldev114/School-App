//
//  Request.h
//  HappiJAR
//
//  Created by kETAN on 25/10/13.
//  Copyright (c) 2013 kETAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject{
    NSMutableDictionary *dictPermValues;
}

@property (nonatomic, strong) NSMutableDictionary *dictPermValues;
@end
