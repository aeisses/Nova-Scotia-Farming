# Nova-Scotia-Farming

This is an iPad app that will run on iOS 7 or 8.

Running:
To run the app just load up the workspace, not the project file, the workspace in the latest
version of xCode and run the app. It should load launch without issues.

Once the app is loaded, touch the soil type buttons on the side, the location of the soil will
be shown on the map. It appears the data set was not complete, so that is disappointing.

Debugging:
The app should run fine. I placed an .ipa file in the main directory. You will not be able to run this, I do not have an enterprise account. But you should be able to build locally.
Zoom in to the Antigonish area to see the soil types. That is the location where the data was from.

Known Bugs:
If you tap on the soil buttons before the polygons have finished loading a crash can occure. This is generally a issue when touching the "All" button. There is a lot of polygons to load when the all button is touched.

TODO:
Remove the interio of the polygons from the map. Ran out of time to do this.
