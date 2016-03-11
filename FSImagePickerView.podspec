
Pod::Spec.new do |spec|
  #项目名称
  spec.name         = 'FSImagePickerView'
  #版本号
  spec.version      = '0.0.1'
  #开源协议
  spec.license      = 'MIT'
  #对开源项目的描述
  spec.summary      = 'FSImagePickerView is a tool to pick images'
  #开源项目的首页
  spec.homepage     = 'https://github.com/FsThatOne'
  #作者信息
  spec.author       = {'wangzhengyi' => 'wangzhengyi@qufenqi.com'}
  #项目的源和版本号
  spec.source       = { :git => 'https://github.com/FsThatOne/FSImagePickerView.git', :tag => '0.0.1' }
  #源文件，这个就是供第三方使用的源文件
  spec.source_files = "FSImagePickerView/*"
  #适用于ios7及以上版本
  spec.platform     = :ios, '7.0'
  #使用的是ARC
  spec.requires_arc = true
  #依赖AFNetworking2.0
  #spec.dependency 'AFNetworking', '~> 2.0'
end

