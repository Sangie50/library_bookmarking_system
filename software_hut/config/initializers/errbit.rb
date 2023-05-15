Airbrake.configure do |config|
  config.api_key = '16758296bbbb68b6a6e000df3d702b98'
  config.host    = 'errbit.hut.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end