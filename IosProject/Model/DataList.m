//
//  DataList.m
//  IosProject
//
//  Created by Rully Winata on 22/10/24.
//

#import "DataList.h"

@implementation DataList

@synthesize dataId;
@synthesize title;
@synthesize userId;
@synthesize body;

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self)
    {
        self.dataId = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.userId = [dict[@"userId"] integerValue];
        self.title = dict[@"title"];
        self.body = dict[@"body"];
    }
    return self;
}


@end

