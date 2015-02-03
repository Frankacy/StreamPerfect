# Uncomment this line to define a global platform for your project
platform :ios, "7.0"

plugin 'cocoapods-keys', {
	:project => "StreamPerfect",
	:target => "StreamPerfect",
	:keys => [
		"TwitchClientID",
		"TwitchClientSecret",
		"GoogleAnalyticsID"
	]
}

target "StreamPerfect" do
	pod 'ReactiveCocoa'
	pod 'ReactiveViewModel'
	pod 'RestKit'
	pod 'SDWebImage'
	pod 'UIAlertView-Blocks'
	pod 'Masonry'
	pod 'GoogleAnalytics-iOS-SDK'
end

target "StreamPerfectTests" do
	pod 'Specta'
	pod 'Expecta'
	pod 'OCMock'
end
