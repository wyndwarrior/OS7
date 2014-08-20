#import "Headers/SBApplicationIcon.h"
#import "DreamBoard.h"
#import "OS7.h"

OS7 *os7;

%hook SBApplicationIcon
-(void)setBadge:(NSString*)badge{
	%orig(badge);
	if(os7)[os7 updateBadge:[self leafIdentifier]];
}
%end

%hook DreamBoard
-(void)loadTheme:(NSString *)theme{
    if([theme isEqualToString:@"OS7"] && os7)return;
    if(os7!=nil && ![theme isEqualToString:@"OS7"]){
        [self unloadTheme];
        [self save:@"Default"];
        %orig(theme);
    }else if(os7==nil && [theme isEqualToString:@"OS7"]) {
        if(![self.currentTheme isEqualToString:@"Default"])[self unloadTheme];
		os7 = [[OS7 alloc] initWithWindow:[self window] array:[self appsArray]];
		[self save:@"OS7"];
        [self showAllExcept:nil];
        [self window].userInteractionEnabled = YES;
	}
    else %orig(theme);
}

-(void)unloadTheme{
	if(os7){
		[os7 release];
		os7 = nil;
	}
    else %orig;
}

-(NSString*)currentTheme{
    if(os7)return @"OS7";
    return %orig;
}

- (void)toggleSwitcher{
    if(os7)
    {
        CGRect frame = os7.mainView.frame;
        if(os7.mainView.frame.origin.y==0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.25];
            os7.mainView.frame = CGRectMake(frame.origin.x,-93,frame.size.width,frame.size.height);
            [UIView commitAnimations];
            [[objc_getClass("DreamBoard") sharedInstance] showAllExcept:nil];
        }
        else [self hideSwitcher];
    }
    else %orig;
}

-(void)hideSwitcher{
    if(os7)
    {
        CGRect frame = os7.mainView.frame;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        os7.mainView.frame = CGRectMake(frame.origin.x,0,frame.size.width,frame.size.height);
        [UIView commitAnimations];
        [[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:os7.mainView];
    }
    else %orig;
}

%end