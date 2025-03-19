# Visual Intelligence Demo
 
## Overview
[Visual Intelligence](https://support.apple.com/guide/iphone/use-visual-intelligence-iph12eb1545e/18.0/ios/18.0) is a new feature introduced by Apple in iOS 18 for models in iPhone 16 family and the iPhone 15 Pro that identifies object, places, dates, phone numbers, and addresses in the camera’s frame. This is achieved by using features of Apple’s [Vision Framework](https://developer.apple.com/documentation/vision) along with on device machine learning models and a knowledge base. If an object or place is not identified with a high degree of confidence using the on-device mode models the feature will make a request to [OpenAI’s API](https://platform.openai.com/docs/guides/images?api-mode=chat&format=base64-encoded) or [Google’s Reverse Image Search](https://images.google.com) depending on if the user wants to get information about what they are looking at or if they want to find similar images.

With an iPhone 14 Pro, I am unable to use this feature but wanted to understand how the feature worked technically. This led me to write this small demo application, which re-implements the basic features of Apple’s Visual Intelligence feature.



## Legal Notices
“Visual Intelligence” is a trademark owned by [Apple](apple.com). This repository serves as a technical demonstrating of how Apple’s Visual Intelligence *might* be working. It does not claim ownership or creation of the term or the idea for the feature.