#include <windows.h>
#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <win32com/client.h>

// Method to initialize PowerPoint
void InitializePowerPoint() {
    CoInitialize(NULL);
    auto application = win32com::client::Dispatch("PowerPoint.Application");
    auto presentation = application.ActivePresentation;

    if (!presentation.SlideShowWindow) {
        presentation.SlideShowSettings.Run();
    }
}

// Method to go to the next slide
void NextSlide() {
    auto application = win32com::client::Dispatch("PowerPoint.Application");
    auto presentation = application.ActivePresentation;
    presentation.SlideShowWindow.View.Next();
}

// Method to go to the previous slide
void PreviousSlide() {
    auto application = win32com::client::Dispatch("PowerPoint.Application");
    auto presentation = application.ActivePresentation;
    presentation.SlideShowWindow.View.Previous();
}

// Method to get the maximum number of slides
int GetMaxSlides() {
    auto application = win32com::client::Dispatch("PowerPoint.Application");
    auto presentation = application.ActivePresentation;
    return presentation.Slides.Count;
}

// Entry point for the DLL
extern "C" __declspec(dllexport) void ControlPowerPoint(int command) {
    switch (command) {
        case 0:
            InitializePowerPoint();
            break;
        case 1:
            NextSlide();
            break;
        case 2:
            PreviousSlide();
            break;
        case 3:
            GetMaxSlides();
            break;
        default:
            break;
    }
    return 0; // Return a default value or handle the error appropriately
}
