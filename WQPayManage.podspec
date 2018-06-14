
Pod::Spec.new do |s|

s.name         = "WQPayManage"
s.version      = "0.0.1"
s.summary      = "Pod库"
s.homepage     = "https://github.com/WQiOS/WQPayManage"
s.license      = "MIT"
s.author       = { "王强" => "1570375769@qq.com" }
s.platform     = :ios, "8.0" #平台及支持的最低版本
s.requires_arc = true # 是否启用ARC
s.source       = { :git => "https://github.com/WQiOS/WQPayManage.git", :tag => "#{s.version}" }

s.ios.deployment_target = '8.0'

# 所需的framework，多个用逗号隔开
s.ios.frameworks = 'SystemConfiguration', 'CoreTelephony','QuartzCore','CoreText','CoreGraphics','UIKit','Foundation','CFNetwork','CoreMotion'

# 所需的library，多个用逗号隔开
s.ios.libraries = 'c++','z'

s.resource = 'AliPaySDK.bundle'
# 使用了第三方静态库
s.ios.vendored_frameworks = 'AliPaySDK.framework'


s.dependency 'ZLUtil', '1.trunk.1'
s.dependency 'ZLUIKit', '1.trunk.1'
s.dependency 'ZLInterface', '1.trunk.1'
s.dependency 'Masonry'
s.dependency 'BlocksKit'


s.subspec 'Controller' do |controller|
controller.source_files = "WQPayManage/Controller/*.{h,m}"
end

s.subspec 'Helper' do |helper|
helper.source_files = "WQPayManage/Helper/*.{h,m}"
end

s.subspec 'Model' do |model|
model.source_files = "WQPayManage/Model/*.{h,m}"
end

s.subspec 'View' do |view|
view.source_files = "WQPayManage/View/*.{h,m}"
end

s.subspec 'ViewModel' do |viewModel|
viewModel.source_files = "WQPayManage/ViewModel/*.{h,m}"
end

end
