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

or

pod 'iBotSDK', '~> 1.9.6'


```

## Usage

### API Key
You can get an api key in  [here](https://admin.istore.camp/).


### Basic
```swift
import iBotSDK

IBotSDK.shared.showIBotButton(in: self.view, apiKey:'YOUR_API_KEY')
```

```objective-c
#import <iBotSDK.h>

[[IBotSDK shared] showIBotButtonIn:[self view] apiKey:@"YOUR_API_KEY"];
```




### Edit IBotChatButton

```swift

let button = IBotSDK.shared.showIBotButton(in: self.view, apiKey:'YOUR_API_KEY')

// change position
button.frame.origin.y = button2.frame.origin.y - 100


// open in navigation viewcontroller
button.openInModal = false

// dragging
button.canDrag = true

// change button default background color
button.buttonBackgroundColor = .white


// open directly
IBotSDK.shared.showChatbot(parent: self, apiKey: 'YOUR_API_KEY', openInModal: false)

```

```objective-c

IBotChatButton *button = [[IBotSDK shared] showIBotButtonIn:[self view] apiKey:@"YOUR_API_KEY"];    

// change position
button.center = CGPointMake(button.center.x, button.center.y - 50);

// open in navigation viewcontroller
button.openInModal = false;

// dragging
button.canDrag = true;

// change button default background color
button.buttonBackgroundColor = UIColor.whiteColor;


```

### Using Callback
채팅창으로부터 메세지를 전달 받아서 직접 지정한 동작을 수행하고자 할때 정의하여 활용하면 됩니다.

```swift

IBotSDK.shared.showIBotButton(in: self.view, apiKey: @"YOUR_API_KEY") { (ibotVC, command) in

    if let _ = ibotVC.navigationController {
        self.showCommandAlert(command)
    }
    else {
        ibotVC.dismiss(animated: true) {
            self.showCommandAlert(command)
        }
    }
}

```


### Disable Animation
챗봇 버튼 애니메이션 재생시 메세지가 노출되는 부분 제거시 showIBotButton()을 호출할때 아래와 같이 playAnimation값을 false로 전달하면 됩니다.

```swift

IBotSDK.shared.showIBotButton(in: self.view, apiKey: @"YOUR_API_KEY", playAnimation: false)

```




## Author

Enliple, ibot@enliple.com


## License

iBotSDK is available under the MIT license. See the LICENSE file for more info.
