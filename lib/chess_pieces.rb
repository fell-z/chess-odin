Dir["./lib/chess_pieces/*.rb"].each { |file| require file.sub(".rb", "") }
