Dir["./chess_pieces/*.rb"].each { |file| require_relative file.sub(".rb", "") }
