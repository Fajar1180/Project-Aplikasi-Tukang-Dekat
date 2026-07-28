//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
import flutter_secure_storage_macos
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FlutterSecureStoragePlugin.register(with: registry.registrar(forPlugin: "FlutterSecureStoragePlugin"))
=======
import file_selector_macos
import flutter_secure_storage_darwin
import geolocator_apple
import package_info_plus
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  FlutterSecureStorageDarwinPlugin.register(with: registry.registrar(forPlugin: "FlutterSecureStorageDarwinPlugin"))
  GeolocatorPlugin.register(with: registry.registrar(forPlugin: "GeolocatorPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
>>>>>>> repo-b/main
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
