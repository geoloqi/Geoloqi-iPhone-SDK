Pod::Spec.new do |s|
  s.name     = 'Geoloqi-iPhone-SDK'
  s.version  = '1.0.0'
  s.homepage = 'https://geoloqi.com/'
  s.source   = { :git => 'git://github.com/geoloqi/Geoloqi-iPhone-SDK.git' }

  s.source_files = 'GeoloqiSDK/*.h'
  s.library = 'Geoloqi-Release','sqlite3'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => "$(SRCROOT)/Pods/Geoloqi-iPhone-SDK/GeoloqiSDK/" }
  s.frameworks = 'CoreLocation'
  s.dependency 'JSONKit'
end
