/*
 
 OS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "SpringBoard/SpringBoard.h"
#import "DreamBoardController.h"
#import "Tile.h"
#import "ApplicationListItem.h"
#import "OS7ViewController.h"

OS7ViewController *viewController;

%hook SBApplicationIcon

-(void)setBadge:(NSString*)badge{
	%orig(badge);
	if(viewController)
		[viewController updateBadgeWithString:badge app:[self leafIdentifier]];
}
%end

%hook DreamBoardController

-(void)loadThemes:(NSString *)theme{
	if([theme isEqualToString:@"OS7"]){
		viewController = [[OS7ViewController alloc] initWithWindow:[self window] array:[self apps]];
		[self setThemeName:@"OS7"];
		[self saveDict:@"OS7"];
	}else
		%orig(theme);
}

-(void)unloadTheme{
	if([[self themeName] isEqualToString:@"OS7"]){
		[viewController release];
		[self setThemeName:nil];
		viewController = nil;
		[self saveDict:@"None"];
	}else
		%orig;
}

- (void)toggleSwitcher{
    if(viewController){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        if(viewController.mainView.frame.origin.y==0){
            [viewController.mainView setFrame:CGRectMake(viewController.mainView.origin.x,-93,CGRectGetWidth(viewController.mainView.frame),CGRectGetHeight(viewController.mainView.frame))];
        }else{
            [viewController.mainView setFrame:CGRectMake(viewController.mainView.origin.x,0,CGRectGetWidth(viewController.mainView.frame),CGRectGetHeight(viewController.mainView.frame))];
        }
        [UIView commitAnimations];
    }else
        %orig;
}

-(void)closeSwitcher{
    if(viewController){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        [viewController.mainView setFrame:CGRectMake(viewController.mainView.origin.x,0,CGRectGetWidth(viewController.mainView.frame),CGRectGetHeight(viewController.mainView.frame))];
        [UIView commitAnimations];
    }else
        %orig;
}

%end