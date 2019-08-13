 
#import "LocalizationSystem.h"

@interface LocalizationSystem ()
@property (nonatomic, copy) NSString *old_lang;
@end

@implementation LocalizationSystem
{
    NSString *lang;
}

//Singleton instance
static LocalizationSystem *_sharedLocalSystem = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;

+ (LocalizationSystem *)sharedLocalSystem
{
	@synchronized([LocalizationSystem class])
	{
		if (!_sharedLocalSystem){
			[[self alloc] init];
		}
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([LocalizationSystem class])
	{
		NSAssert(_sharedLocalSystem == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedLocalSystem = [super alloc];
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}


- (id)init
{
    if ((self = [super init])) 
    {
		//empty.
		bundle = [NSBundle mainBundle];
	}
    return self;
}

- (void)setLang:(NSString *)_lang
{
    if (lang != _lang)
    {
//        [self willChangeValueForKey:@"lang"];
        [lang release];
        lang = [_lang copy];
//        [self didChangeValueForKey:@"lang"];
    }
}

- (NSString *)lang
{
    if (lang == nil)
    {
        NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocLang"];
        if (s == nil)
            s = @"vi";
        
        self.lang = s;
    }
    
    return lang;
}

// Gets the current localized string as in NSLocalizedString.
//
// example calls:
// AMLocalizedString(@"Text to localize",@"Alternative text, in case hte other is not find");
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{
	return [bundle localizedStringForKey:key value:comment table:nil];
}


// Sets the desired language of the ones you have.
// example calls:
// LocalizationSetLanguage(@"Italian");
// LocalizationSetLanguage(@"German");
// LocalizationSetLanguage(@"Spanish");
// 
// If this function is not called it will use the default OS language.
// If the language does not exists y returns the default OS language.

- (void) setLanguage:(NSString*)l
{
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	

	if (path == nil)
		//in case the language does not exists
		[self resetLocalization];
	else
		bundle = [[NSBundle bundleWithPath:path] retain];
    
    self.lang = l;
}

// Just gets the current setted up language.
// returns "es","fr",...
//
// example call:
// NSString * currentL = LocalizationGetLanguage;
- (NSString*) getLanguage{

	NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

	NSString *preferredLang = [languages objectAtIndex:0];

	return preferredLang;
}

// Resets the localization system, so it uses the OS default language.
//
// example call:
// LocalizationReset;
- (void) resetLocalization
{
	bundle = [NSBundle mainBundle];
}

@synthesize lang = lang;
@end
