//
//  CTRootCellItem.h
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTRootCellItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *imageHref;

@property (nonatomic, assign) BOOL isEmpty;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGRect titleFrame;

@property (nonatomic, strong) UIFont *descFont;
@property (nonatomic, strong) UIColor *descColor;
@property (nonatomic, assign) CGRect descFrame;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, assign) CGFloat CellHeight;

- (void)calculateFrames;

@end
