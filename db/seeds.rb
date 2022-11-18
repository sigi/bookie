# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
teams = %w[
Argentinien
Australien
Belgien
Brasilien
Costa Rica
Dänemark
Deutschland
Ecuador
England
Frankreich
Ghana
Iran
Japan
Kamerun
Kanada
Katar
Kroatien
Marokko
Mexiko
Niederlande
Polen
Portugal
Saudi-Arabien
Schweiz
Senegal
Serbien
Spanien
Südkorea
Tunesien
Uruguay
USA
Wales
]

divisions = [
  'Gruppe A',
  'Gruppe B',
  'Gruppe C',
  'Gruppe D',
  'Gruppe E',
  'Gruppe F',
  'Gruppe G',
  'Gruppe H',
  'Achtelf.',
  'Viertelf.',
  'Halbf.',
  'Finale',
]

Team.create!(teams.map {|t| {name: t} })
Division.create!(divisions.map {|d| {name: d} })
