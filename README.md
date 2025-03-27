# Visual Intelligence Demo

![Screenshot](https://www.cfridlington.com/assets/projects/visual-intelligence-demo/vision-analysis.png)

[Visual Intelligence](https://support.apple.com/guide/iphone/use-visual-intelligence-iph12eb1545e/18.0/ios/18.0) is a new feature introduced by Apple in iOS 18 that identifies object, places, dates, phone numbers, and addresses in the camera’s frame to provide contextual information.

This *technical demo* recreates Visual Intelligence as a means to understand how the application is leveraging different frameworks and technologies. Initial classification is performed using Apple’s [Vision Framework](https://developer.apple.com/documentation/vision) and a knowledge base. This identifies objects in the frame and retrieves information about it and associated links where users can learn more. The Vision Framework is also used to detect text within the captured frame. If this text contains the details for a calendar event these are parsed and the user is presented with an option to add the detected event to their calendar. Furthermore, all recognized text is stored and can be read aloud on request of the user.

If the object in frame is not recognized with a high degree of confidence by the Vision Framework, the user is presented with two external options: to “Ask” ChatGPT or to “Search” for similar images using Google. To create this the application makes calls to the [OpenAI’s API](https://platform.openai.com/docs/guides/images?api-mode=chat&format=base64-encoded) and the [Google Cloud Vision API](https://cloud.google.com/vision/docs/detecting-web).

As part of the debugging process, I also implemented a “Developer Options” view which allows you to enter API keys, adjust the prompt used with OpenAI queries, and change granted permissions. A “History” view was also created, using SwiftData as the underlaying persistence container, to allow user’s to view past queries and their results.

The application is written in Swift and the interface is written using SwiftUI. The capture effect was created using a custom metal shader overlayed by an animated mesh gradient. The design is a *near* copy of Visual Intelligence’s actual design but some liberties were taken since I don’t have access to Visual Intelligence on my iPhone 14 Pro.

If you want to run this demo you can clone the repository on GitHub. The application will prompt you for API keys for OpenAI and Google Cloud Vision when using those external services. These can be generated in the OpenAI Developer Portal and the Google Cloud Console respectively. Alternatively, you can [request](https://www.cfridlington.com/contact) I share my personal credentials if you are just looking to try the demo out once.

#### Legal Notices
“Visual Intelligence” is a trademark owned by [Apple](apple.com). This repository serves as a technical demonstrating of how Apple’s Visual Intelligence *could* be working. It does not claim ownership or creation of the term or the idea for the feature.
