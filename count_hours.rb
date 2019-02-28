#!/usr/bin/env ruby

require 'date'
require 'time'
require 'time_difference'

# Location Hour Counter
# Expects kml, coord1 lat, long, coord2 lat, long

lat1, lat2 = [ARGV[1].to_f, ARGV[3].to_f].sort
long1, long2 = [ARGV[2].to_f, ARGV[4].to_f].sort

coord_box = [
  [lat1, long1],
  [lat2, long2]
]

data = []

all_data = File.read(ARGV[0]).split(?\n)[7..-5].map(&:strip)
all_data.each_slice(2) do |a|
  date = Time.parse(a[0][6..-8]).localtime
  long, lat, uncertainty = *a[1][10..-12].split.map(&:to_f)

  if lat.between?(coord_box[0][0], coord_box[1][0]) \
      && long.between?(coord_box[0][1], coord_box[1][1])
    data << [date, lat, long]
  end
end

hours_chunks = data.chunk { |a| a[0].yday }

hours_list = hours_chunks.map do |a|
  TimeDifference.between(a[1].first[0], a[1].last[0]).in_hours
end

puts "#{hours_list.sum} hours total."
puts "#{hours_list.size} days, #{hours_list.sum / hours_list.size} hours per day average."
