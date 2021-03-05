module Globals
  class App
    TITLE = 'Chatroom'
    MIN_USER_AGE = 18
    MAX_USER_AGE = 150
    MAX_DOB = Date.current.advance(years: -MIN_USER_AGE)
    MIN_DOB = Date.current.advance(years: -MAX_USER_AGE)
  end
end
