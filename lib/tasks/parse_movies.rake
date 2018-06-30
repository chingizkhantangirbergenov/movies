namespace :parse do
	desc "Parse movies"
	task cities: :environment do
		require "nokogiri"
		require "open-uri"

		html = Nokogiri::HTML(open("http://kino.kz/new/schedule"))
		html.css("#city-select option").each do |city|
			City.create(name: city.text)
		end
	end

	task cinemas: :environment do
		require "nokogiri"
		require "open-uri"
		id = 1
		html = Nokogiri::HTML(open("http://kino.kz/?ver=old"))
		html.css(".menu_items").each do |part|
			part.css(".menu_item a").each do |cinema|
				cite_ind = cinema['href'][21..-1]
				cinema = cinema.text
				Cinema.create(name: cinema, cite_index: cite_ind, city_id: id)
			end
			id = id + 1
		end
	end

	task movies: :environment do
		require "nokogiri"
		require "open-uri"
		html = Nokogiri::HTML(open("http://kino.kz/thisweek.asp"))
		html.css(".mov_week_detail").each do |part|
			title = part.css(".title_red").text[1..-2]
			path = part.css(".movie_poster img").attr('src')
			image_url = "http://kino.kz" + path
			description = part.css("td[colspan=3] //div[2]").text
			Movie.create(title: title, description: description, image_url: image_url)
		end

	end

	task sessions: :environment do
		require "nokogiri"
		require "open-uri"
		cinema = Cinema.pluck(:cite_index)
		cinema.each do |indice|
			url = "http://kino.kz/new/schedule_cinema?id=#{indice}&sort=0&day=-1&startTime=06%3A00&endTime=05%3A59"
			cinema_id = Cinema.find_by_cite_index(indice).id
			html = Nokogiri::HTML(open(url), nil, 'UTF-8')
			html.css("tr.seance_active td.time").each do |part|
				movie_name = part.attr('data-value')
				movie_time = part.text
				movie = Movie.find_by_title(movie_name)
				if  movie != nil
					movie_id = Movie.find_by_title(movie_name).id
				else
					Movie.create(title: movie_name)
					movie_id = Movie.find_by_title(movie_name).id
				end
				splitted = movie_time.split(":")
				time_now = Time.now
				hour_now = time_now.hour
				minute_now = time_now.min
				if(Integer(splitted[0]) > hour_now)
					does_open = true
				elsif(Integer(splitted[0]) == hour_now)
					if(Integer(splitted[1]) > minute_now)
						does_open = true
					else
						does_open = false
					end
				else
					does_open = false
				end
			Session.create(cinema_id: cinema_id, movie_id: movie_id, time: movie_time, open: does_open)
			end
			
		end
	end
end
