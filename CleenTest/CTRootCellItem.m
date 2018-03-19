
//
//  CTRootCellItem.m
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import "CTRootCellItem.h"

#define kCTRootCellHorizontalMargin 10
#define kCTRootCellVerticalMargin 10
#define kCTRootCellHorizontalPadding 10
#define kCTRootCellVerticalPadding 10

#define kCTRootCellImageWidth 100

@implementation CTRootCellItem

+ (void)load
{
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"desc" : @"description"};
    }];
}

- (BOOL)isEmpty
{
    return self.title.length == 0
    && self.desc.length == 0
    && self.imageHref.length == 0;
}
- (UIFont *)titleFont
{
    return [UIFont systemFontOfSize:15];
}

- (UIFont *)descFont
{
    return [UIFont systemFontOfSize:13];
}

- (UIColor *)titleColor
{
    return [UIColor blueColor];
}

- (UIColor *)descColor
{
    return [UIColor blackColor];
}

- (void)calculateFrames
{
    [self calculateTitleFrame];
    [self calculateDescFrame];
    [self calculateImageFrame];
    
    [self calculateCellHeight];
}

- (void)calculateTitleFrame
{
    if (self.title.length == 0) {
        self.titleFrame = CGRectZero;
    }
    
    if (self.titleFrame.size.height == 0) {
        CGFloat titleX = kCTRootCellHorizontalMargin;
        CGFloat titleY = kCTRootCellVerticalMargin;
        CGFloat titleW = kScreenW - 2 * kCTRootCellHorizontalMargin;
        CGSize size = [self.title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:self.titleFont}
                                               context:nil].size;
        CGFloat titleH = size.height;
        self.titleFrame = CGRectMake(titleX, titleY, titleW, titleH);
    }
}

- (void)calculateDescFrame
{
    if (self.desc.length == 0) {
        self.descFrame = CGRectMake(0, CGRectGetMaxY(self.titleFrame), 0, 0);
    }
    
    if (self.descFrame.size.height == 0) {
        CGFloat descW = self.imageHref.length == 0 ? (kScreenW - 2 * kCTRootCellHorizontalMargin) : (kScreenW - 2 * kCTRootCellHorizontalMargin - kCTRootCellHorizontalPadding - kCTRootCellImageWidth);
        CGFloat descX = kCTRootCellHorizontalMargin;
        CGFloat descY = CGRectGetMaxY(self.titleFrame) + (self.titleFrame.size.height == 0 ? kCTRootCellHorizontalMargin : kCTRootCellHorizontalPadding);
        CGSize size = [self.desc boundingRectWithSize:CGSizeMake(descW, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:self.descFont}
                                              context:nil].size;
        CGFloat descH = size.height;
        self.descFrame = CGRectMake(descX, descY, descW, descH);
    }
}

- (void)calculateImageFrame
{
    if (self.imageHref.length == 0) {
        self.imageFrame = CGRectZero;
    }
    
    if (self.imageFrame.size.height == 0) {
        CGFloat imageW = kCTRootCellImageWidth;
        CGFloat imageX = kScreenW - kCTRootCellHorizontalMargin - imageW;
        CGFloat imageY = CGRectGetMinY(self.descFrame);
        CGFloat imageH = kCTRootCellImageWidth;
        self.imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
    }

}

- (void)calculateCellHeight
{
    CGFloat maxYOfDesc = CGRectGetMaxY(self.descFrame);
    CGFloat maxYOfImage = CGRectGetMaxY(self.imageFrame);
    CGFloat maxYOfTitle = CGRectGetMaxY(self.imageFrame);
    
    CGFloat maxY = maxYOfDesc > maxYOfImage ? maxYOfDesc : maxYOfImage;
    maxY = maxY > maxYOfTitle ? maxY : maxYOfTitle;
    
    self.CellHeight = maxY + kCTRootCellVerticalMargin;
}

@end
