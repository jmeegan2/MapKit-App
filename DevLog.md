# DevLog
Issues: 
* have to make sure i add the tollsPreference to map call
* There is no free API to check for gas prices in the US, for now ill just have the user enter it, i know its one more step but I dont want to pay for an API atm
* Not sure how to format the map in the view, looks too small at the bottom, may remove later
* AppleMaps not taking tollPreference upon opening, on the dev forums people said this isnt possible but the thread was old so Im not sure 
* Difficulty adding border polyline below main polyline (asked question on stackOverflow and reddit), I saw people do this but they used coordinates and not routes for polyline, right now im only able to draw one polyline route but with cooordinates it doesnt work
* Not able to pass tollsPreference or highwayPreference when opening the maps app from mine, not sure if possible, read on old threads its not
* Had been using GLGeocode but it didnt accept things like 'The White House' as an entry it wanted the actual address which isnt very practical for user to have to to type in so I changed it to use MKLocalSearch so it recognizes those kind of non-specifc locations
* Didn't realize that if I get a 'Directions not available' error message from 'error.localizedDescription' that its most likely a problem with the roads and not my actual code. Like you cant get directions to Yellowstone if the roads are blocked with snow or some kind of natural event impeading traffic
* Not sure how i can add the userLocation into the address rows 

Random notes:

Use this for annotations: https://www.hackingwithswift.com/books/ios-swiftui/improving-our-map-annotations

Challenge get all necessary done in next three days 4/19 on 4/21 be done

Necessary ToDo before launching
* Refactoring for neatness and good practices (DO again)
* Menu creation for avoid highways and tolls option (DONE)
* Have loading screen wait for the map to load before showing the screen with the values or maybe put give it its own loading screen
* Add user current location functionality 
* add in webscraping for the gas price (DONE)
* Add in MKLocaleSearchCompleter

Nice to haves 
* Background for the route polyline 
* Have the UIApplication.shared.open for open AppleMaps be able to take avoid tolls and highway preferences, dont think its possible though 
* Have users be able to choose google maps and apple maps 

Change popover for gas price to a alert 

Failed to publish to App store, no Info.plist file but I'll try to finish tmrw and upload it.

Reason its poping down before u enter location is because it has a .focus($isTextFieldFocused)


5/9 
Currently working on clearing the search results when u click on a different locationField so its not the first thing that pops
up during ur new search *

5/12 
Need to make it so that the user will on be shown the annotation.title if its zoomed in on. Right now the 
annotation is too long sometimes now that I'm using address.title & address.subtitle if clicked on row.  

5/15
viewModel.locationString is my userlocation

5/23
Its hard to understand how apple is presenting their values on maps, sometimes they floor and other times they round. 
