//
//  GradientButton.m
//

#import "GradientButton.h"


@interface GradientButton ()
- (void)initLayers;
- (void)initBorder;
- (void)addShineLayer;
//- (void)addHighlightLayer;
@end


@implementation GradientButton


#pragma mark -
#pragma mark Initialization


- (void)awakeFromNib {
    [self initLayers];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayers];
    }
    return self;
}


- (void)initLayers {
    [self initBorder];
    [self addShineLayer];
    [self addHighlightLayer];
}


- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
}


- (void)addShineLayer {
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = self.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [self.layer addSublayer:shineLayer];
}


#pragma mark -
#pragma mark Highlight button while touched


- (void)addHighlightLayer {
    highlightLayer = [CALayer layer];
//    highlightLayer.backgroundColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:0.75].CGColor;
    highlightLayer.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:0.25].CGColor;    
    highlightLayer.frame = self.layer.bounds;
    highlightLayer.hidden = YES;
    [self.layer insertSublayer:highlightLayer below:shineLayer];
}


- (void)setHighlighted:(BOOL)highlight {
    highlightLayer.hidden = !highlight;
    [super setHighlighted:highlight];
}


@end
