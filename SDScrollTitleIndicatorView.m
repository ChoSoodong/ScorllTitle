




#import "SDScrollTitleIndicatorView.h"

@interface SDScrollTitleIndicatorView()

/** 滚动背景view */
@property (nonatomic, strong) UIScrollView *backScrollView;
/** 指示器 */
@property (nonatomic, strong) UIView *lineView;
/** label数组 */
@property (nonatomic, strong) NSArray *labelsArray;
/** 上一个label */
@property (nonatomic, strong) UILabel *preLabel;

@end

@implementation SDScrollTitleIndicatorView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_backScrollView];
        
        _lineView = [UIView viewWithBackgroundColor:UIThemeColor];
        _lineView.frame = CGRectMake(KScaleW(16), self.bounds.size.height-KScaleW(2), KScaleW(12), KScaleW(2));
        [_backScrollView addSubview:_lineView];

        NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:titles.count];
        [arrayM removeAllObjects];
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            
            //计算标题宽 高
            CGFloat titleWidth = [title widthWithFontSize:KScaleW(14) height:MAXFLOAT];
            CGFloat titleHeight = self.bounds.size.height - KScaleW(2);
            
            
            UILabel *titleLabel = [UILabel labelWithBoldFontSize:KScaleW(13.33) textColor:SUB_TITLE_COLOR numblerOfLines:1 text:title];
            titleLabel.userInteractionEnabled = YES;
            if(i == 0){
                titleLabel.frame = CGRectMake(KScaleW(16), 0, titleWidth, titleHeight);
                titleLabel.textColor = UIThemeColor;
                titleLabel.font = [UIFont boldSystemFontOfSize:KScaleW(13.33)];
            }else{
                titleLabel.frame = CGRectMake(KScaleW(31.33)+CGRectGetMaxX(_preLabel.frame), 0, titleWidth, titleHeight);
            }
            
            titleLabel.tag = i + 1000;
            [_backScrollView addSubview:titleLabel];
            
            UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
            [titleLabel addGestureRecognizer:titleTap];
        
            [arrayM addObject:titleLabel];
            self.labelsArray = arrayM.copy;
            
            if (i == titles.count -1) {
                [_backScrollView setContentSize:CGSizeMake(CGRectGetMaxX(titleLabel.frame)+KScaleW(16), self.bounds.size.height)];
            }
            
            _preLabel = titleLabel;
        
        
        }
        
    }
    return self;
}

-(void)titleTapAction:(UITapGestureRecognizer *)tap{
    
    UIView *tapView = tap.view;
    UILabel *currentLabel = (UILabel *)tapView;
    if (currentLabel == nil) return;
   
    NSInteger currentTag = currentLabel.tag - 1000;
    
    currentLabel.textColor = UIThemeColor;
    currentLabel.font = [UIFont boldSystemFontOfSize:KScaleW(13.33)];
    for (UILabel *subLabel in self.labelsArray) {
        if (currentLabel != subLabel) {
            subLabel.textColor = SUB_TITLE_COLOR;
            subLabel.font = [UIFont systemFontOfSize:KScaleW(13.33)];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (currentTag == 0) {
             self.lineView.transform = CGAffineTransformIdentity;
        }else{
            CGFloat transformX = currentLabel.frame.origin.x - KScaleW(16);
            self.lineView.transform = CGAffineTransformMakeTranslation(transformX, 0);
        }
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(SDScrollTitleIndicatorView:selectIndex:)]) {
        [self.delegate SDScrollTitleIndicatorView:self selectIndex:currentTag];
    }
    
    
    //让当前点击的label显示在可视范围的中间
    //最大允许滚动的距离
    CGFloat maxOffsetX = self.backScrollView.contentSize.width - self.backScrollView.bounds.size.width;
    if (maxOffsetX <= 0) { //如果内容宽度小于scrollview的宽度,就不变化
        return;
    }
    //最小就是0
    CGFloat minOffsetX = 0;
    //可以滚动的范围
    CGFloat needScrollOffsetX = currentLabel.center.x - self.backScrollView.bounds.size.width * 0.5;
    
    if (needScrollOffsetX < maxOffsetX && needScrollOffsetX >minOffsetX) {
        
        [self.backScrollView setContentOffset:CGPointMake(needScrollOffsetX, 0) animated:YES];
        
    }else if(needScrollOffsetX >= maxOffsetX){
     
        [self.backScrollView setContentOffset:CGPointMake(maxOffsetX, 0) animated:YES];
       
    }else if(needScrollOffsetX <= minOffsetX){
        
        [self.backScrollView setContentOffset:CGPointMake(minOffsetX, 0) animated:YES];
    }
    
}

@end
