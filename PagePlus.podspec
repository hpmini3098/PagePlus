Pod::Spec.new do |s|
  s.name      = 'PagePlus'
  s.version   = '1.0.0'
  s.license   = 'MIT'
  s.summary   = 'A Page component base UIScrollView'
  s.author = {
    'Derek Chen'  => 'derek.amz@gmail.com'
  }
  s.source = {
    :git => '',
    :tag => 'v1.0.0'
  }
  s.source_files = 'Source/*.{h,m}'
  s.requires_arc = true
end