# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

Movie.delete_all
ProductionCompany.delete_all
MovieGenre.delete_all
Genre.delete_all
Page.delete_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='production_companies';")

filename = Rails.root.join("db/top_movies.csv")

puts "Loading Movies from CSV file: #{filename}"

csv_data = File.read(filename)

movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  production_company = ProductionCompany.find_or_create_by(name: m['production_company'])

  if production_company && production_company.valid?
    movie = production_company.movies.create(
      title: m['original_title'],
      year: m['year'],
      duration: m['duration'],
      description: m['description'],
      average_vote: m['avg_vote']
    )
    puts "Invalid movie #{m['original_title']}" unless movie&.valid?
    genres = m["genre"].split(",").map(&:strip)

    genres.each do |genre_name|
      genre = Genre.find_or_create_by(name: genre_name)
      MovieGenre.create(movie:, genre:)
    end
  else
    puts "Invalid production company #{m["production_company"]} for movie #{m["original_title"]}"
  end
  puts m['original_title']
end

puts "Created #{ProductionCompany.count} Production Companies"
puts "Created #{Movie.count} Movies"
puts "Created #{Genre.count} Genres"
puts "Created #{MovieGenre.count} Movie Genres"

Page.create(
  title: "About The Data",
  content: "The data powering this website is provided by Kaggle",
  permalink: "about_the_data"
)

Page.create(
  title: "Contact Us",
  content: "If you like this website, please reach out to faker@notfaker.com",
  permalink: "contact"
)

puts "Created #{Page.count} Pages"