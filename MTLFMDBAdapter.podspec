#
# Be sure to run `pod lib lint MTLFMDBAdapter.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MTLFMDBAdapter"
  s.version          = "0.3.2"
  s.summary          = "A Mantle adapter to serialize to and from FMDB."
  s.description      = <<-DESC
                       MTLFMDBAdapter is a Mantle adapter that can be used
                       to serialize a Mantle object to FMDB (SQLite) by creating
                       the necessary INSERT/UPDATE/DELETE statements and vice versa.
                       DESC
  s.homepage         = "https://github.com/tanis2000/MTLFMDBAdapter"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Valerio Santinelli" => "santinelli@altralogica.it" }
  s.source           = { :git => "https://github.com/tanis2000/MTLFMDBAdapter.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/santinellival'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  #s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Mantle', '~> 2.0'
  s.dependency 'FMDB', '~> 2.3'
end
