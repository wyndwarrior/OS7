@interface DreamBoard : NSObject{
}

@property(nonatomic, readonly) NSMutableArray *appsArray;
@property(nonatomic, retain) UIWindow *window;
@property(readonly)BOOL isEditing;

+(DreamBoard*)sharedInstance;

-(void)hideSwitcher;
-(void)showSwitcher;
-(void)toggleSwitcher;

-(void)startEditing;
-(void)stopEditing;

-(void)loadTheme:(NSString*) theme;
-(void)unloadTheme;
-(void)showAllExcept:(UIView*)_view;
-(void)hideAllExcept:(UIView*)view;

-(NSString*)currentTheme;
-(void)save:(NSString *)theme;

@end
