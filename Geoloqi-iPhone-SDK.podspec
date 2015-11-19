Pod::Spec.new do |s|

  s.name         = "Geoloqi-iPhone-SDK"
  s.version      = "12.297"
  s.summary      = "Sample iPhone app using the Geoloqi iPhone SDK"

  s.description  = <<-DESC
  The Esri Geotrigger Service replaced the The Geoloqi API which is now offline.
  The new Geotrigger SDK can be found here: https://cocoapods.org/pods/GeotriggerSDK

  Please see https://developers.arcgis.com/en/features/geotrigger-service/ for more info.
                   DESC

  s.homepage     = "http://developers.geoloqi.com/ios/"
  s.license      = {:type => "Commercial", :file => "APPCELERATOR_LICENSE" }
  s.author             = { "Geoloqi" => "dev@geoloqi.com" }
  s.platform     = :ios, "5.0"
  s.source       = {
    :git => "https://github.com/geoloqi/Geoloqi-iPhone-SDK.git",
    :tag => "12.296"
  }

  #s.source_files  = "GeoloqiSDK/*.h"
  #s.preserve_paths = "GeoloqiSDK/*.h"
  s.frameworks  = "CoreLocation", "MessageUI"
  s.libraries = "sqlite3", "Geoloqi-$(CONFIGURATION)"
  s.requires_arc = false

  s.xcconfig = {
    "LIBRARY_SEARCH_PATHS" => "$(PODS_ROOT)/Geoloqi-iPhone-SDK/GeoloqiSDK" ,
    "OTHER_LDFLAGS" => "-ObjC"
  }
  #s.dependency "JSONKit", "~> 1.4"

  s.deprecated = true
end
