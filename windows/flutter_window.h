#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include <memory>

#include "ppt_control.cpp"

class FlutterWindow : public flutter::FlutterViewController {
 public:
  FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  virtual void OnCreate();
  virtual void OnDestroy();

 private:
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

void PptControlPluginRegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar);

#endif  // RUNNER_FLUTTER_WINDOW_H_
