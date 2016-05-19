# PlaybasisUnityPlugin

This project utilizes [UnityMobilePlugin](https://github.com/haxpor/UnityMobilePlugin) as a starting point for implmenting Unity Plugin for [Playbasis SDK](http://dev.playbasis.com/).

It uses Unity 5.3.2f1.

# Build
## iOS

1. Export into XCode project from Unity
2. Change `Deployment target` to `8.0` (if not yet)
3. Link against `Security.framework` in Build Phases
4. Add `-ObjC` for Other Linker Flags under Linking in Build Settings
