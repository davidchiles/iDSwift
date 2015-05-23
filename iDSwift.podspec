Pod::Spec.new do |s|

  s.name         = "iDSwift"
  s.version      = "0.0.1"
  s.summary      = "A Swift way of using OpenStreetMap iD editor presets."

  s.description  = <<-DESC
                   A Swift way of using OpenStreetMap iD editor presets.

                   DESC

  s.homepage     = "https://github.com/davidchiles/iDSwift.git"

  s.license      = "CC0"

  s.author             = { "David Chiles" => "dwalterc@gmail.com" }
  s.social_media_url   = "http://twitter.com/dchiles"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/davidchiles/iDSwift.git", :submodules => true}
  
  
  s.default_subspecs = 'standard', 'iD'

  s.subspec "standard" do |ss|
    ss.source_files  = "Classes", "iDSwift/*.swift"
  end

  s.subspec "iD" do |ss|
    ss.resource_bundles = {
      "PresetsInfo" =>  ["Submodules/iD/data/presets/*.json"],
      "Preset" => ["Submodules/iD/data/presets/presets/*/*.json", "Submodules/iD/data/presets/presets/*.json"]
      }
  end

end
