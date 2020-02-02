Pod::Spec.new do |s|
  s.name         = "DSFTouchBar"
  s.version      = "0.9"
  s.summary      = "An NSTouchBar wrapper"
  s.description  = <<-DESC
    Simple Sparkline View for macOS, iOS and tvOS
  DESC
  s.homepage     = "https://github.com/dagronf"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  s.social_media_url   = ""
  s.osx.deployment_target = "10.13"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.subspec "Core" do |ss|
    ss.source_files  = "Sources/DSFTouchBar/**/*.swift"
  end

  s.osx.framework  = 'AppKit'

  s.swift_version = "5.0"
end
