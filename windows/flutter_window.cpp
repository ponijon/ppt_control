#include "flutter_window.h"

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include "ppt_control.cpp"

#include <windows.h>

class PptControlPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "ppt_control",
        &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<PptControlPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  PptControlPlugin() {}

  virtual ~PptControlPlugin() {}

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    if (call.method_name().compare("controlPowerPoint") == 0) {
      int command = std::get<int>(call.arguments());
      ControlPowerPoint(command);
      result->Success();
    } else {
      result->NotImplemented();
    }
  }
};

// Called when the plugin is registered.
void PptControlPluginRegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  PptControlPlugin::RegisterWithRegistrar(registrar);
}
