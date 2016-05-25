## **H19 Code Challenge ­ Marvel API **


### **App Description**

Using this application, users will be able to browse through the Marvel library of characters. 

The data is available by connecting to the [Marvel API] [1]

The mockups and assets to use for the challenge are:

- **iOS** [Mockup][2] & [Assets­][3]

- **Android** [Mockup][4] & [Assets­][5]

### Content Overview

- #### List of Characters

	In this view, you should present a list of characters loaded from the Marvel API character index. Notice that the when reaching the end of the list, if there are additional results to show, you should load and present the next page.

- #### Filter Results

	When tapping on the magnifier icon, you should be able to search for characters by name. To do this, use the same endpoint used to list characters and use the name param to filter results.

- #### Character Details

	When selecting a character, you should present a detail view of that character. Most of this information is already available on the result of the first API call, except for the images to be presented on the comics/series/stories/events sections. Those images can be fetched from the resourceURI and should be lazy loaded. That same behaviour is expected when expanding those images.


### **Challenge Objectives**

This challenge will be used as a base for the technical interview with the Hole19 team. 

During the interview we will discuss your architectural choices, use of good practices and your general understanding of 
what you just did. So refrain from copying code online. Along with a fully working application, we expect you to deliver 
a suite of UI/Unit tests. Finally, the code should be versioned using git and shared with us through any 
git repository hosting service.

At Hole19 we value attention to design. So, apart from your code quality, we’ll also be evaluating how you replicate 
the mocked UI. 

Note that not all animations and transitions were included in the mockup, thus we expect you to apply 
widely known iOS/Android design patterns. If you have any questions, you can email us at jobs@hole19golf.com. Good luck!

[1]: http://developer.marvel.com/          "Marvel API"
[2]: https://marvelapp.com/279b309		    "Mockup"
[3]: http://bit.ly/1LcMgwO				    "Assets"
[4]: https://marvelapp.com/c9d03f			"Mockup"
[5]: http://bit.ly/1SzkwUJ					"Assets"