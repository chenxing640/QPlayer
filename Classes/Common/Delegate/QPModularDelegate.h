//
//  QPModularDelegate.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseDelegate.h"

@protocol QPPresenterDelegate <BaseDelegate>
- (void)setView:(NSObject *)view;
- (void)setViewController:(UIViewController *)viewController;
@optional
- (void)present;
- (void)presentWithModel:(id)model viewController:(UIViewController *)viewController;
@end
