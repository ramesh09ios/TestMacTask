//
//  FoderListTableView.h
//  MacTask
//
//  Created by Ramesh Pedapati on 11/01/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoderListTableView : NSObject
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* size;
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSURL* fileURL;
@property(assign) NSInteger sizeValue;



@end

NS_ASSUME_NONNULL_END
