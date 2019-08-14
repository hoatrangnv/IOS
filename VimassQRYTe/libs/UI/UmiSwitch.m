//
//  UmiSwitch.m
//  ViMASS
//
//  Created by Ngo Ba Thuong on 10/21/13.
//
//

#import "UmiSwitch.h"

@interface UmiSwitch ()
@property (nonatomic, retain) UIImageView *v_on;
@property (nonatomic, retain) UIImageView *v_off;
@end

@implementation UmiSwitch
{
    BOOL off;
    UIImageView *v_on;
    UIImageView *v_off;
}

-(UIImageView *)v_on
{
    if (v_on == nil)
    {
        UIImage *img = [UIImage imageNamed:@"setting_status_off.png"];// [self imageForState:UIControlStateNormal];
        v_on = [[UIImageView alloc] initWithImage:img];
        [self addSubview:v_on];
    }
    return v_on;
}
-(UIImageView *)v_off
{
    if (v_off == nil)
    {
        UIImage *img = [UIImage imageNamed:@"setting_status_on.png"];//[self imageForState:UIControlStateSelected];
        v_off = [[UIImageView alloc] initWithImage:img];
        [self addSubview:v_off];
    }
    return v_off;
}

- (void)setState:(BOOL)on animate:(BOOL)animate;
{
    off = !on;
    if (animate == NO)
    {
        self.v_on.frame = CGRectMake(
                                     on ? 0 : self.frame.size.width,
                                     (self.frame.size.height - self.v_on.frame.size.height)/2,
                                     self.v_on.frame.size.width,
                                     self.v_on.frame.size.height);
        self.v_on.alpha = on ? 1 : 0;
        
        self.v_off.frame = CGRectMake(
                                     on ? 0 : self.frame.size.width,
                                     (self.frame.size.height - self.v_on.frame.size.height)/2,
                                     self.v_on.frame.size.width,
                                     self.v_on.frame.size.height);
        self.v_off.alpha = on ? 1 : 0;
        return;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.v_on.frame = CGRectMake(
                                     on ? 0 : self.frame.size.width,
                                     (self.frame.size.height - self.v_on.frame.size.height)/2,
                                     self.v_on.frame.size.width,
                                     self.v_on.frame.size.height);
        self.v_on.alpha = on ? 1 : 0;
        
        self.v_off.frame = CGRectMake(
                                      on ? 0 : self.frame.size.width,
                                      (self.frame.size.height - self.v_off.frame.size.height)/2,
                                      self.v_off.frame.size.width,
                                      self.v_off.frame.size.height);
        self.v_off.alpha = on ? 0 : 1;
    }];
}
- (void)did_touchup_inside
{
    [self setState:off animate:YES];
}

- (void)init_UmiSwitch
{
    [self addTarget:self action:@selector(did_touchup_inside) forControlEvents:UIControlEventTouchUpInside];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self init_UmiSwitch];
    }
    return self;
}

-(void)dealloc
{
    self.v_on = nil;
    self.v_off = nil;
    [super dealloc];
}

@synthesize v_on = v_on;
@synthesize v_off = v_off;

@end
