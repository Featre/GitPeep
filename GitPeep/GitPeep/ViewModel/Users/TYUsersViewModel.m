//
//  TYUsersViewModel.m
//  GitPeep
//
//  Created by IGEN-TECH on 2018/2/28.
//  Copyright © 2018年 tianyao. All rights reserved.
//

#import "TYUsersViewModel.h"

@interface TYUsersViewModel ()

@end

@implementation TYUsersViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self);
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        
        [self.services pushViewModel:[[TYUsersViewModel alloc] initWithServices:self.services params:@{@"title" : @"DDD"}] animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [[TYNetworkEngine sharedInstance] searchUsersWithPage:1 q:@"location:beijing" sort:@"followers" location:@"beijing" language:@"所有语言" completionHandle:^(NSDictionary *responseDictionary) {
            NSLog(@"response:%@", responseDictionary)
        } errorHandle:^(NSError *error) {
            NSLog(@"error:%@", error)
        }];
        // 请求
        [subscriber sendNext:@[@"", @"", @"", @"", @"", @""]];
        [subscriber sendCompleted];
        return nil;
    }];
    return signal;
}

@end
