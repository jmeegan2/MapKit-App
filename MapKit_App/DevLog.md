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


Random notes:

Use this for annotations: https://www.hackingwithswift.com/books/ios-swiftui/improving-our-map-annotations


