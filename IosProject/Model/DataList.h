//
//  dataList.h
//  IosProject
//
//  Created by Rully Winata on 18/10/24.
//

#import <Foundation/Foundation.h>

@interface DataList : NSObject

@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *body;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
