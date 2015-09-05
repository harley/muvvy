# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

use_frameworks!

def shared_pods
	pod 'AFNetworking'
	pod 'PKHUD', :git => "https://github.com/pkluz/PKHUD.git"
  pod 'ReachabilitySwift', git: 'https://github.com/ashleymills/Reachability.swift'
  pod 'FontAwesome.swift'
end

target 'muvvy' do
  shared_pods
end

target 'muvvyTests' do
  shared_pods
end
