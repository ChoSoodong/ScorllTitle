




#import <UIKit/UIKit.h>

@class SDScrollTitleIndicatorView;

@protocol SDScrollTitleIndicatorViewDelegate<NSObject>

-(void)SDScrollTitleIndicatorView:(SDScrollTitleIndicatorView *_Nullable)view selectIndex:(NSInteger)selectIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SDScrollTitleIndicatorView : UIView

/** 代理属性 */
@property (nonatomic, weak) id<SDScrollTitleIndicatorViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
