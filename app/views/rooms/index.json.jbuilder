json.rooms @rooms do |room|
  json.partial! 'room', room: room
end