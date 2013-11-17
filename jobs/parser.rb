require './models'
require 'mechanize'
require 'pry'
require 'csv'
require 'geocoder'
require 'open-uri'
require 'json'

class Parser
  STACK_URL = "http://careers.stackoverflow.com/jobs?pg="
  GITHUB_URL = "https://jobs.github.com/positions.json?page="

  def initialize
    @agent ||= Mechanize.new
  end
  

  def scrape_stack
    (1..33).each do |page|
      page_url = STACK_URL + page.to_s
      page = @agent.get(page_url)
      links = page.links_with(class: "job-link", href: /^\/jobs\/[0-9]*\//)
      jobs = []
      links.each do |link|
        begin
          page = link.click
          data = build_stack_data(link.href, page)
          StackJob.create(data)
          sleep(1)
        rescue => e
          puts "OUCH! #{e.message}"
          puts link
          File.open('scrape.log', 'a') { |file| file.puts("#{link.href}\t#{e.message}") }
        end
      end
    end
  end

  def scrape_github
    (0..5).each do |page|
      page_url = GITHUB_URL + page.to_s
      jobs = JSON.parse(URI.parse(page_url).read)
      jobs.each do |j|
        begin
          data = build_github_data(j)
          GithubJob.create(data)
        rescue => e
          puts e.message
          File.open('scrape.log', 'a') { |file| file.puts("#{JSON.dump(j)}\t#{e.message}") }
        end
      end
    end
  end

  def reconcile_stack_log
    File.open('scrape.log').each_line do |line|
      link = line.split("\t")[0]
      begin
        url = "http://careers.stackoverflow.com#{link}"
        page = @agent.get(url)
        data = build_data(link, page)
        StackJob.create(data)
      rescue => e
        puts e.message
        puts link
        File.open('scrape1.log', 'a') { |file| file.puts("#{link}\t#{e.message}") }
      end
    end
  end

  def reconcile_github_log
    File.open('scrape.log').each_line do |line|
      job = JSON.parse(line.split("\t")[0])
      binding.pry
      begin
        data = build_github_data(job)
        GithubJob.create(data)
      rescue => e
        puts e.message
        File.open('scrape1.log', 'a') { |file| file.puts("#{JSON.dump(j)}\t#{e.message}") }
      end
    end
  end

  def build_stack_data(link, page)
    job_id = get_id(link)
    data = { 'external_job_id' => job_id, 'url' => "#{STACK_URL[0..-5]}/#{job_id}"  }
    data['title'] = page.links_with(class: "title job-link").first.text
    data['company'] = page.links_with(class: "employer").first.text
    data.merge!(get_locations(page.at("span.location").text))
    data['desc_role'] = clean_text(page.search(".description")[0].text.strip.gsub!(/\s+/, ' '))
    desc_qual = page.search(".description")[1]
    data['desc_qual'] = desc_qual && clean_text(desc_qual.text.strip.gsub!(/\s+/, ' '))
    data
  end

  def build_github_data(job)
    { title: job['title'], description: clean_text(job['description']) + job['how_to_apply'], locations: get_locations(job['location']), posted_date: job['created_at'], url: job['url'], company: job['company'], company_url: job['company_url'], company_logo: job['company_logo'], external_job_id: job["id"], type: job['type']  }
  end

  def get_id(text)
    r = /^\/jobs\/(?<job_id>.*)\//
    matches = text.match(r)
    matches['job_id']
  end

  #one location only for stackcareers
  def get_locations(text)
    location = text.gsub(/\(.*\)/,'').strip
    latlng = Geocoder.search(location)[0].data["geometry"]["location"]
    { 'locations' => [{ 'location'=> location, 'latitude'=> latlng['lat'], 'longitude'=> latlng['lng'] }] }
  end


  def clean_text text
    return nil if text.nil?
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :UNIVERSAL_NEWLINE_DECORATOR => true       # Always break lines with \n
    }
    text.encode(Encoding.find('ASCII'), encoding_options)
  end

end
