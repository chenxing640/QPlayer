//
//  QPAboutMeTableHeader.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseView.h"

@interface QPAboutMeTableHeader : BaseView
// UI Widget.
@property (weak, nonatomic) IBOutlet UIImageView *logoBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *briefIntroLabel;

// Layout Constraint.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBgImgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBgImgViewHeight;

@end
