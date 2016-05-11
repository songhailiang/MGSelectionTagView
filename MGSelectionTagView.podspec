Pod::Spec.new do |s|
    s.name         = 'MGSelectionTagView'
    s.version      = '1.0.0'
    s.summary      = 'a selectable tag view that support single or multiple,adaptive width and height '
    s.homepage     = 'https://github.com/songhailiang/MGSelectionTagView'
    s.license      = 'MIT'
    s.authors      = {'songhailiang' => 'jaysea094@126.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/songhailiang/MGSelectionTagView.git', :tag => s.version}
    s.source_files = 'MGSelectionTagView/Source/*.{h,m}'
    s.requires_arc = true
end
