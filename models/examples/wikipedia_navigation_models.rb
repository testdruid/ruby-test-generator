#!/usr/bin/env ruby

require 'watir'
require 'webdrivers'

class WikipediaNavigationModels


  # Vertex methods
  # Start vertex
  def self.v_start
    @browser = Watir::Browser.new  :firefox
    return "SUCCESS. Started Firefox."
  end

  def self.v_wikipedia_main
    @browser.wait_until { |b| b.title == "Wikipedia, the free encyclopedia" }
    return "SUCCESS. Arrived at Main Page."
  end

  def self.v_about
    @browser.wait_until { |b| b.title == "Wikipedia:About - Wikipedia" }
    return "SUCCESS. Arrived at About Page."
  end

  def self.v_contents
    @browser.wait_until { |b| b.title == "Wikipedia:Contents - Wikipedia" }
    return "SUCCESS. Arrived at Contents Page."
  end

  def self.v_community_portal
    @browser.wait_until { |b| b.title == "Wikipedia:Community portal - Wikipedia" }
    return "SUCCESS. Arrived at Community Portal Page."
  end

  def self.v_recent_changes
    @browser.wait_until { |b| b.title == "Recent changes - Wikipedia" }
    return "SUCCESS. Arrived at Recent Changes Page."
  end

  # Edge methods
  def self.e_main
    @browser.goto 'http://en.wikipedia.org/wiki/Main_Page'
    return "SUCCESS. Browsed to Main Page."
  end

  def self.e_about
    @browser.goto 'http://en.wikipedia.org/wiki/Wikipedia:About'
    return "SUCCESS. Browsed to About Page."
  end

  def self.e_contents
    @browser.goto 'http://en.wikipedia.org/wiki/Wikipedia:Contents'
    return "SUCCESS. Browsed to Contents Page."
  end

  def self.e_community
    @browser.goto 'http://en.wikipedia.org/wiki/Wikipedia:Community_Portal'
    return "SUCCESS. Browsed to Community Portal Page."
  end

  def self.e_recent
    @browser.goto 'http://en.wikipedia.org/wiki/Special:Recentchanges'
    return "SUCCESS. Browsed to Recent Changes Page."
  end

end