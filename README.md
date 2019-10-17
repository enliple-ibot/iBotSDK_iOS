# iBotSDK

[![CI Status](https://img.shields.io/travis/DongHoon/iBotSDK.svg?style=flat)](https://travis-ci.org/DongHoon/iBotSDK)
[![Version](https://img.shields.io/cocoapods/v/iBotSDK.svg?style=flat)](https://cocoapods.org/pods/iBotSDK)
[![License](https://img.shields.io/cocoapods/l/iBotSDK.svg?style=flat)](https://cocoapods.org/pods/iBotSDK)
[![Platform](https://img.shields.io/cocoapods/p/iBotSDK.svg?style=flat)](https://cocoapods.org/pods/iBotSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 11.0+
* Xcode 11 (Swift 4.0)

## Installation

iBotSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iBotSDK'
```

## Usage
### init
```swift
import iBotSDK

iBotSDK.shard.setUp(apiKey: 'Your APIKey')
```

### Add IBotChatButton 
```swift
IBotSDK.shared.showIBotButton(in: self.view)
```
Or just Add IBotChatButton in StoryBoard or XIB


## Author

Enliple, ibot@enliple.com


## License

iBotSDK is available under the MIT license. See the LICENSE file for more info.
