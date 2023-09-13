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

filename = Rails.root.join("db/top_movies.csv")

puts "Loading Movies from CSV file: #{filename}"

csv_data = File.read(filename)

movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  production_company = ProductionCompany.find_or_create_by(name: m['production_company'])

  if production_company && production_company.valid?

  else
    puts "Invalid production company #{m["production_company"]} for movie #{m["original_title"]}"
  end
  puts m['original_title']
end

puts "Created #{ProductionCompany.count} Production Companies"