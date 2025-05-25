# Changelog - Sublime Treasure v1.1.0

## Performance Optimizations

### Caching System
- Added caching system for configurations and localization files
- Significantly reduced file loading calls
- Improved response times during treasure interactions

### Animation Optimizations
- Implemented cache for animation dictionaries
- Added periodic cleanup system for unused animations
- Improved animation loading with timeout system
- Reduced memory consumption related to animations

### Loop and Thread Improvements
- Redesigned adaptive interval system in client loops
- Optimized distance checks with progressive intervals
- Reduced CPU load during treasure hunt events
- Increased event end verification interval on server side

### Discord Webhook Queue System
- Implemented queue system for Discord webhooks
- Prevented rate limiting issues
- Sequential notification sending with controlled delay
- Improved event logging reliability

### Anti-Cheat Verification Optimizations
- Enhanced distance verification algorithm
- Implemented preliminary map quadrant verification
- More efficient cheat attempt detection
- Reduced server load during verifications

### Network Call Reduction
- Grouped player notifications
- Optimized client-server communications
- Reduced bandwidth usage

## Technical Improvements

### Resource Preloading
- Added support for model and prop preloading
- Optimized configuration in fxmanifest.lua
- Reduced initial loading times

### Extended Use of Constants
- Extended use of `<const>` for immutable variables
- Improved Lua code execution performance

### Memory Management
- Periodic cleanup of unused resources
- Proactive memory release
- Reduced overall memory footprint

## Bug Fixes
- Fixed potential hangs in animation loops
- Improved error handling during configuration loading
- Prevented memory leaks related to animation dictionaries

---

*Note: This update primarily focuses on performance optimization and does not add new features. All existing functionality remains unchanged but runs more efficiently.*