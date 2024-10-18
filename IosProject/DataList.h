//
//  dataList.h
//  IosProject
//
//  Created by Rully Winata on 18/10/24.
//

#import <Foundation/Foundation.h>

@interface DataList : NSObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
