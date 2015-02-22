# Nova-Scotia-Farming

This is an iPad app that will run on iOS 7 or 8.

Running:
To run the app just load up the workspace, not the project file, the workspace in the latest
version of xCode and run the app. It should load launch without issues.

Once the app is loaded, touch the soil type buttons on the side, the location of the soil will
be shown on the map. It appears the data set was not complete, so that is disappointing.

Debugging:
The app runs well at the moment. There is one known bug. Do not touch the screen while the app is loading the data.
This will cause the managedContext to error and crash. I did not have a chance to fix this bug.
