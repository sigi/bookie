# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
teams = %w[
Deutschland
Österreich
Belgien
Kroatien
Tschechien
Dänemark
England
Finnland
Frankreich
Ungarn
Italien
Niederlande
Nordmazedonien
Polen
Portugal
Russland
Schottland
Slovakei
Spanien
Schweden
Schweiz
Türkei
Ukraine
Wales
]

divisions = [
  'Gruppe A',
  'Gruppe B',
  'Gruppe C',
  'Gruppe D',
  'Gruppe E',
  'Gruppe F',
  'Achtelf.',
  'Viertelf.',
  'Halbf.',
  'Finale',
]

Team.create!(teams.map {|t| {name: t} })
Division.create!(divisions.map {|d| {name: d} })
