#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

require 'aws-sdk'

ec2 = AWS::EC2.new()

get '/' do
  slim :home
end

get '/regions' do
  @regions = ec2.regions
  slim :regions
end

get '/regions/:myregion' do
	@myregion = params[:myregion]
	@sdb = AWS::SimpleDB.new(:region => @myregion)
	@domains = @sdb.domains
	slim :show_region
end

not_found do
	slim :not_found
end

__END__
@@layout
doctype html
html
  head
    meta charset="utf-8"
    title CSPP 51083 WebApp
    link rel="stylesheet" href="/styles.css"
  body
    h1 CSPP 51083 WebApp
    	li <a href="/" title="Home">Home</a>
    	li <a href="/regions" title="Regions">Regions</a>
    == yield
@@regions
h2 Regions
= @regions
@@show_region
h1 domains
= @domains
@@not_found
h2 Error 404
p Bad link. <a href='/'>Home Page</a>
