
//
//  CTRootCell.m
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import "CTRootCell.h"

@interface CTRootCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *image;

@end

@implementation CTRootCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.image];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - getter setter

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIImageView *)image
{
    if (_image == nil) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor redColor];
    }
    return _image;
}

- (void)setItem:(CTRootCellItem *)item{
    _item = item;
    self.titleLabel.text = _item.title;
    self.titleLabel.font= _item.titleFont;
    self.titleLabel.textColor = _item.titleColor;
    self.titleLabel.frame = _item.titleFrame;
    
    self.descLabel.text = _item.desc;
    self.descLabel.font= _item.descFont;
    self.descLabel.textColor = _item.descColor;
    self.descLabel.frame = _item.descFrame;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:_item.imageHref] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.image.frame = _item.imageFrame;
}

@end
