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

    def ss.getNewFileName(existingPath,depth)
      @name = File.basename(existingPath, ".json")
      @modifiedPath = existingPath
      for i in 0..depth
        @name = @name + "-" + File.basename(File.dirname(@modifiedPath))
        @modifiedPath = File.expand_path("..",@modifiedPath)
      end
      @newPath = File.join('./presets/',@name+".json")
      if File.exist?(@newPath)
        self.getNewFileName(existingPath,depth+1)
      else 
        return @newPath
      end

    end

    def ss.recursiveJSONCheck(directory)
      Dir.foreach(Dir.pwd) do |item|
        print item
      end
      Dir.foreach(directory) do |item|
        
        next if item == '.' or item == '..' or item == '.DS_Store'
        path = File.join(directory, item)
        if File.directory?(path)
          recursiveJSONCheck(path)
        elsif File.extname(path) == ".json"
          @newPath = self.getNewFileName(path,0)
          #print @newPath + "\n"
          FileUtils.mkdir_p(File.dirname(@newPath))
          FileUtils.copy_file(path,@newPath,:force => true)
        end   
      end
    end

    ss.recursiveJSONCheck('./Submodules/iD/data/presets/presets/')

    ss.resource_bundles = {
      "PresetsInfo" =>  ["Submodules/iD/data/presets/*.json"],
      "Preset" => ["presets/*.json"]
      }

  end

end
